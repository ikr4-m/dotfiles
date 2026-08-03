---
name: git-staged-message
description: Suggests a git commit message based ONLY on currently staged files. Trigger this when the user asks for a commit message suggestion.
---

# Instructions

1. **Focus on Staged Changes**: Only analyze the changes that have already been staged by the user (e.g., by checking `git diff --cached`).
2. **No Proactive Staging**: If you notice that there are unstaged changes in the repository, DO NOT proactively stage them yourself using tools or commands, and do not select which files to stage. Leave all staging decisions entirely to the user.
3. **Generate Suggestion**: Provide a concise and meaningful commit message based on the staged diff. Use Conventional Commits format (e.g., feat, fix, docs) unless instructed otherwise. Provide a short title (under 50 characters) and a detailed body if necessary.
