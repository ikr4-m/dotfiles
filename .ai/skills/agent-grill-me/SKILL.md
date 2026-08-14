---
name: agent-grill-me
description: Interactively grills the user with technical and architectural questions to uncover missing requirements, design constraints, and edge cases before implementation. Trigger when the user types `/grill-me`, "grill me", or requests interactive requirement gathering.
---

# Grill Me Skill

Trigger this skill when the user explicitly requests a "grill me" session, types `/grill-me`, or asks to be interviewed about a feature or system design before planning or coding.

## Goal
Conduct a structured, high-signal interactive interview ("grilling") to surface hidden assumptions, resolve ambiguities, evaluate architectural trade-offs, and clarify edge cases.

## Grilling Principles

1. **High Signal & Probing**: Ask concise, deeply relevant technical questions. Avoid superficial or trivial questions that can already be inferred from existing codebase context.
2. **One Step at a Time**: Group questions logically into focused rounds (1 to 3 questions per turn) so the user is not overwhelmed.
3. **Challenge Assumptions**: Actively challenge fragile design choices, missing error handling, unhandled edge cases, backward compatibility issues, or unscalable data patterns.
4. **Iterative Refinement**: Process user answers and update your internal understanding after each round. Continue grilling until all critical ambiguity is resolved.

## Interview Domains to Cover

- **Problem Scope & Boundaries**: Core requirements, non-goals, and constraints.
- **Architecture & Data Flow**: Component responsibilities, state management, DB schemas, API contracts.
- **Edge Cases & Failure Modes**: Error handling, timeout policies, invalid states, rate limits.
- **User & Developer Experience**: Interfaces, CLI flags, configuration formats, ergonomics.

## Workflow

1. **Initial Assessment**: Briefly state what problem/feature is being analyzed based on current context.
2. **Interactive Rounds**: Present 1-3 targeted questions at a time and wait for user response.
3. **Consolidation**: Once all ambiguities are cleared, summarize the agreed-upon design decisions and signal readiness for planning/implementation.
