---
name: agent-just-print-in-chat
description: Instructs the agent to output requested text, code snippets, or markdown directly into the chat interface instead of creating or modifying files. Trigger when the user explicitly asks to "print", "show", or output something in the chat.
---

# Instructions

1. **Direct Chat Output**: When the user requests a script, markdown, or code snippet, output it directly in your chat response using markdown code blocks.
2. **No File Operations**: Do NOT create new files, do NOT create markdown artifacts, and do NOT modify any existing files on the system to fulfill the request.
3. **Length Check**: As long as the requested output is reasonably short and will not overwhelm the chat log, print it entirely in the chat.
4. **Formatting**: Always use proper markdown syntax and language-specific code block highlights for readability.
