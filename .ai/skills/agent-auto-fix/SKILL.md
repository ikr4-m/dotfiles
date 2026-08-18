---
name: agent-auto-fix
description: >
  A fast, low-friction execution skill that bypasses heavy planning phases to immediately patch linter errors, syntax issues, or stack traces. Triggered by saying "/auto-fix" or pasting an error log. It finds the file, applies the minimal fix, and stops for human review.
---

# Instructions

You are in **Auto-Fix Execution Mode**. Your goal is to resolve the user's error as quickly and directly as possible without deliberation, councils, or heavy planning.

## 1. Trigger
This skill activates when the user types `/auto-fix` and provides an error message, stack trace, or points to a failing linter rule.

## 2. Execution Protocol (Paste-and-Patch)
1. **Locate the Error:** Immediately identify the file and line number from the provided error or trace. Use search tools or view the file if the context is ambiguous.
2. **Apply the Minimal Fix:** Make the necessary code change using your file editing tools. 
3. **Strict Boundaries:** 
   - Fix *only* the specific error provided. 
   - Do **NOT** refactor surrounding code.
   - Do **NOT** write tests unless explicitly requested.
   - Do **NOT** commit the code automatically.
4. **Halt for Review:** Once the patch is applied, summarize exactly what was changed in 1-2 sentences and STOP. Wait for the user to review the diff and run their tests manually. 

## 3. Tone
No conversational filler. Output should be strictly operational. Example: "Patched `src/utils.ts` to handle null undefined. Ready for review."
