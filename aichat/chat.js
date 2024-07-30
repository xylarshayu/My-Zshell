import Groq from "groq-sdk";
import fs from 'fs/promises';
import path from 'path';
import kleur from 'kleur';

const CONFIG_PATH = path.join(process.env.HOME, 'aichat', 'config.json');
const CHATS_DIR = path.join(process.env.HOME, 'aichat', 'chats');

const MESSAGE_SEPARATOR = '\n<<<MESSAGE_END>>>\n';
const USER_PREFIX = '<<<USER>>>';
const ASSISTANT_PREFIX = '<<<ASSISTANT>>>';
const TOKEN_USAGE_PREFIX = '<<<TOKENSUSED>>>';

const groq = new Groq({ apiKey: process.env.AICHATKEY });

async function loadConfig() {
  try {
    const configData = await fs.readFile(CONFIG_PATH, 'utf-8');
    return JSON.parse(configData);
  }
  catch (error) {
    if (error.startsWith('ENOENT: no such file or directory')) console.log("No config.json file found, did you make it yet? Check out the readme first.");
    else console.log(error)
  }
}

async function saveConfig(config) {
  await fs.writeFile(CONFIG_PATH, JSON.stringify(config, null, 2));
}

export async function onLoad() {
  const config = await loadConfig();
  [config.currentChat, config.previousChat] = [null, config.currentChat];
  await saveConfig(config);
}

export async function getModels() {
  const models = await groq.models.list();
  console.log('The following models are available. Choose index when selecting model');
  models.data.forEach((model, index) => console.log(`${index + 1}. ${model.id}`));
};

export async function setModel(index) {
  const [models, config] = await Promise.all([groq.models.list(), loadConfig()]);
  config.model = models.data[index].id;
  await saveConfig(config);
  console.log('Current model set to: ', config.model);
};

export async function getCurrModel() {
  const config = await loadConfig();
  console.log(config.model);
}

async function saveChatMessage(chatFile, role, content) {
  const messageContent = `${role === 'user' ? USER_PREFIX : ASSISTANT_PREFIX}${content}${MESSAGE_SEPARATOR}`;
  await fs.appendFile(path.join(CHATS_DIR, chatFile), messageContent);
}

async function setTokenUsage(chatFile, numTokens) {
  const content = await fs.readFile(path.join(CHATS_DIR, chatFile), 'utf-8');
  const lines = content.split('\n');
  const tokenLine = `${TOKEN_USAGE_PREFIX}:${numTokens}`;
  lines[0].startsWith(TOKEN_USAGE_PREFIX) ? lines[0] = tokenLine : lines.unshift(tokenLine);
  const updatedContent = lines.join('\n');
  await fs.writeFile(path.join(CHATS_DIR, chatFile), updatedContent, 'utf-8');
}

async function getTokenUsage(chatFile) {
  try {
    const content = await fs.readFile(path.join(CHATS_DIR, chatFile), 'utf-8');
    const lines = content.split('\n');
    if (!lines[0].startsWith(TOKEN_USAGE_PREFIX)) return -1;
    else return Number(lines[0].split(':').at(-1));
  }
  catch (error) {
    if (error.message.startsWith('ENOENT: no such file or directory')) return 0;
    else console.log(error);
  }
}

async function getChatContent(chatFile, input) {
  let messages = [];
  try {
    const content = await fs.readFile(path.join(CHATS_DIR, chatFile), 'utf-8');
    messages = content.split(MESSAGE_SEPARATOR);
    messages = messages
      .filter(msg => msg.trim() !== '')
      .map(msg => {
        if (msg.startsWith(USER_PREFIX)) {
          return { role: 'user', content: msg.slice(USER_PREFIX.length) };
        } else if (msg.startsWith(ASSISTANT_PREFIX)) {
          return { role: 'assistant', content: msg.slice(ASSISTANT_PREFIX.length) };
        } else return { role: 'system', content: msg }; // idk what else to do here but let's see
      });
  } catch (error) {
    if (!error.message.startsWith('ENOENT: no such file or directory')) console.log(error);
  }
  messages.unshift({ role: "system", content: "You are a helpful AI assistant." });
  messages.push({ role: "user", content: input });
  return messages;
}

export async function main(input) {
  const config = await loadConfig();
  const messages = await getChatContent(config.currentChat, input);

  const chatCompletion = await groq.chat.completions.create({
    messages: messages,
    model: config.model,
  });

  
  const response = chatCompletion.choices[0]?.message?.content || "";
  console.log(kleur.cyan(kleur.bgBlue(kleur.bold("LLM:")) + "\n" + response));
  
  await saveChatMessage(config.currentChat, 'user', input);
  saveChatMessage(config.currentChat, 'assistant', response); // Not awaiting result not needed

  const tokensUsedBefore = await getTokenUsage(config.currentChat);
  let tokensUsed = chatCompletion.usage.total_tokens + tokensUsedBefore;
  if (tokensUsed >= 1000000) console.log(kleur.yellow('⚠ Btw a million tokens have been used in this chat. Maybe start a new one?'));
  setTokenUsage(config.currentChat, tokensUsed); // Not awaited either for same reason as prev
}

export async function consoleTotalTokensUsed() {
  const config = await loadConfig();
  const tokensUsed = await getTokenUsage(config.currentChat);
  console.log("Current token usage is: ", tokensUsed);
  if (tokensUsed >= 1000000) console.log(kleur.yellow("Exceeds a million btw, maybe start a new chat."));
}

export async function newChat() {
  const config = await loadConfig();
  const newChatFile = `chat_${Date.now()}.txt`;
  config.previousChat = config.currentChat;
  config.currentChat = newChatFile;
  await saveConfig(config);
  console.log(`New chat created: ${newChatFile}`);
}

export async function continueChat() {
  const config = await loadConfig();
  if (!config.currentChat) {
    console.log("Starting a new one, fetch previous if you wanna continue the previous one.");
    await newChat();
  }
}

export async function previousChat() {
  const config = await loadConfig();
  if (config.previousChat) {
    [config.currentChat, config.previousChat] = [config.previousChat, config.currentChat];
    await saveConfig(config);
    console.log(`Switched to previous chat: ${config.currentChat}`);
  } else {
    console.log("No previous chat available.");
  }
}

export async function listPinnedChats() {
  const config = await loadConfig();
  if (config.pinnedChats.length > 0) {
    console.log("Pinned chats:");
    config.pinnedChats.forEach((chat, index) => console.log(`${index + 1}. ${chat}`));
  } else {
    console.log("No pinned chats.");
  }
}

export async function pinCurrentChat() {
  const config = await loadConfig();
  if (config.currentChat && !config.pinnedChats.includes(config.currentChat)) {
    config.pinnedChats.push(config.currentChat);
    await saveConfig(config);
    console.log(`Pinned current chat: ${config.currentChat}`);
  } else {
    console.log("No current chat or chat already pinned.");
  }
}