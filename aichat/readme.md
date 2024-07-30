This is a dirt-simple terminal interface (if you will) for chatting with LLMs. Supports stuff like chat history and changing models. Chats get stored in plaintext in a chats directory.

You should have a config.json file in this directory with the following structure:

```json
{
  "model": "llama-3.1-8b-instant",
  "previousChat": "chat_1722309273750.txt",
  "currentChat": "chat_1722313931559.txt",
  "pinnedChats": []
}
```
Enjoy