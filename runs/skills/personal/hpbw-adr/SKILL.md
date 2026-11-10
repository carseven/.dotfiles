---
name: hpbw-adr
description: Draft an HP Build Workspace architecture decision record and implementation plan from Confluence, Jira and Figma, through a grilling interview checked against current repository code.
disable-model-invocation: true
---

# HPBW ADR

Turn product documentation into an ADR for the HP Build Workspace (HPBW) platform: decisions, trade-offs, edge cases and an implementation plan.
The ADR lands in `aec_documentation`.
Every technical claim carries **evidence**: a source locator, a `file:line` at `origin`, a migration, or read-only AWS output.
Implementation code is a separate task that starts after the user reviews the ADR.

Example: `/hpbw-adr LFPSW-18501, <Confluence link>, <Figma link>. Decide how the files view shows processing files.`

## 1. Read the sources

Collect the Jira key, the Confluence page and the Figma node.
Ask for any that are missing and not discoverable from the others.
Read each through the user's logged-in browser, following [references/sources.md](references/sources.md).
Give every requirement an identifier (S1-R1) with its source locator.
List acceptance criteria, design states, open questions and stated feature flags.

This step ends when every acceptance criterion and design state has an identifier, and every unreachable source is named.

## 2. Find the facts

Look facts up yourself and keep questions for decisions.
Read code at `origin`: local clones lag the default branch by hundreds of commits.
Cover the surfaces the feature touches:

- Services and clients, through `git grep` at `origin/<default>` or `gh api`.
- Existing ADRs, OpenAPI and AsyncAPI in `aec_documentation`.
- Database schema, from the `aec_database` migrations.
- Deployed wiring (S3 triggers, queues, event rules), through the read-only guard in [references/read-only-access.md](references/read-only-access.md).
- UI components, from the Tangram repository at the version the frontend pins.

Use sub-agents for wide reads.
Tell each one to read `origin/<default>`, to cite `file:line`, and to report what it could not check.
Hold a claim until a second look at `origin` agrees with it.

This step ends when each design question has cited facts and each contradiction between sources and code is listed.

## 3. Grill

Run the interview with the `grilling` skill: load it with the skill tool, and read `../grill-me/SKILL.md` if the dependency is unclear.
If it is unavailable, report the missing dependency.

Open with a short summary of the facts that shape the decisions.
Ask each frontier as numbered questions with a recommended answer, so "yes" accepts it.
Cover the surfaces the sources imply: data model, API, events, clients, flags, rollout order, failure paths, compatibility with existing clients, trade-offs, and what stays out of scope.
When a later check contradicts an answered question, say so, give the corrected fact and re-ask.
Record each confirmed answer as a decision (D1) with its alternatives.

This step ends when the frontier is empty and the user confirms the shared understanding in words.

## 4. Write the ADR

Follow [references/adr-format.md](references/adr-format.md).
Create the branch from `origin/main` in `aec_documentation`, then write the ADR and any contract change the decisions require (OpenAPI, AsyncAPI, product docs).
Plain words, short sentences, tables for options, transitions and edge cases, Mermaid for flows.
Cite evidence for each fact. Put judgements in Decision and Consequences.
Put unverified items under Open questions.
Add an implementation plan: one row per repository, a rollout order where each step is safe without the next, the feature flag, and the tests.

This step ends when every confirmed decision appears in the ADR, and every ADR claim traces to a fact or a decision.

## 5. Validate and hand off

Run the validations from `adr-format.md`, then commit on the local branch.
Report what was validated and what was not, every correction to an earlier answer, and the open items.
Push and open the pull request only when the user asks, using the repository's pull request template.
Begin implementation only after the user approves the ADR.

This step ends when the user has the commit, the validation results and the list of open items.
