# Universal Project Rules & Conventions

This document establishes the global baseline conventions for all projects in this workspace. It serves as the domain context for the AI assistant to ensure consistent, high-quality execution without requiring redundant prompting.

## 1. Architectural Philosophy (Hybrid Approach)
We use a combination of functional programming safety and defensive object-oriented structure:
- **Layered Architecture:** Separate concerns cleanly (e.g., UI/View layer, Business Logic layer, Data Access layer). Use interfaces or abstract classes to define boundaries where appropriate.
- **Fail-Fast & Functional Core:** Inside the layers, favor immutable data structures and pure functions. Validate inputs immediately (fail-fast) and return early to avoid deep nesting.
- **YAGNI (You Aren't Gonna Need It):** Do not over-engineer the object-oriented layers. Only abstract when there is a proven need for multiple implementations. 

## 2. Error Handling & Defense
- **Comprehensive Boundaries:** Use `try/catch` blocks at the boundaries of your system (e.g., API routes, database calls, external services).
- **Explicit Error Passing:** Inside business logic, favor explicitly passing errors rather than throwing them unexpectedly. 
- **No Silent Failures:** Never write empty `catch` blocks. All caught errors must be logged or transformed and bubbled up.

## 3. Code Generation Rules for AI
- **Read Before Writing:** Always use search tools to understand the existing surrounding code before proposing a fix.
- **Shortest Working Diff:** When fixing a bug, provide the absolute minimum code required to fix the issue. Avoid unrequested refactors.
- **Preserve Existing Patterns:** If a file uses a specific naming convention or structural pattern, mimic it perfectly, even if it contradicts a general rule.
