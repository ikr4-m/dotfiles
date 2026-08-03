---
name: git-create-mr-message
description: Generates a Merge Request (MR) message based on a specified target branch. Trigger this skill when the user asks to create an MR message or pull request description.
---

# Instructions

1. **Require Target Branch**: You MUST know the target branch before generating the MR message. 
2. **No Proactive Searching**: If the user does not explicitly provide the target branch in their prompt, DO NOT proactively search for it using git commands or attempt to guess it. 
3. **Ask the User**: Instead, stop immediately and ask the user to specify the target branch (e.g., "Could you please specify the target branch for this Merge Request?").
4. **Generate Message**: Once the target branch is provided, analyze the diff between the current branch and the target branch. Formulate a structured MR message containing a clear title, a summary of changes, and any relevant context or testing details.

# Merge Request Structure

## Title

The title of merge request must using [The Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Body Message

```md
<desc_and_the_summary>

# Changes

<foreach changes>
## <changes_title>
<map of bullet_list_of_changes = {
    - **<title>**: <desc> <if changes = breaking>**[BREAKING]**<endif>
}> 
<endforeach>

<if have breaking_changes>
# Breaking Changes
<endif>

<if have migration>
# Migration
<bullet_list_of_migration>
<endif>
```
