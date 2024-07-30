import { onLoad, main, newChat, continueChat, previousChat, listPinnedChats, pinCurrentChat, getModels, setModel, getCurrModel, consoleTotalTokensUsed } from './chat.js';

const command = process.argv[2];

switch (command) {
  case '--load':
    await onLoad();
    break;
  case '--new':
    await newChat();
    break;
  case '--prev':
    await previousChat();
    break;
  case '--pinned':
    await listPinnedChats();
    break;
  case '--pin':
    await pinCurrentChat();
    break;
  case '--list':
    await getModels();
    break;
  case '--set':
    const index = Number(process.argv[3]);
    if (isNaN(index)) {
      console.error(`Argument ${process.argv[3]} is not a number`);
      break;
    }
    await setModel(process.argv[3] - 1);
    break;
  case '--current':
    await getCurrModel();
    break;
  case '--tokens':
    await consoleTotalTokensUsed();
    break;
  case '--help':
    const commands = ['--load', '--new', '--prev', '--pinned', '--pin', '--list', '--set', '--current', '--help', '--tokens', '... Or just normally chatting. Please use doube-quotation marks otherwise you\'ll get annoyances in the terminal.'];
    console.log("Available commands are:");
    commands.forEach((val) => console.log(val));
    console.log("Enjoy.");
    break;
  case undefined:
    await newChat();
    break;
  default:
    await continueChat();
    await main(process.argv.slice(2).join(' '));
}