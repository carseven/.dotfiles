# Agent interviews and design records

Use ordinary implementation workflows for routine, well-defined tasks.
Use the upstream `grill-with-docs` skill when the user explicitly requests a design interview.
It combines `grilling` and `domain-modeling`; this repository does not maintain a fork.

## Make the skill available

The existing skills installer selects all upstream Matt Pocock skills globally for Copilot and Claude Code.
It therefore includes `grill-with-docs` when upstream provides it.
See the [public skills reference](../site/src/content/docs/reference/skills.md) before installation:
the installer can change global RTK integration and agent hooks.

After installation, refresh the active agent's skill discovery if needed.
Invoke the available skill explicitly:

```text
/grill-with-docs Design the next installation workflow for this repository.
```

If that skill is unavailable in the host, report the limitation.
The equivalent workflow requires both `grilling` and `domain-modeling`; do not silently substitute an unstructured interview.

## Conduct the interview

1. Inspect the relevant source and current documentation. Establish environmental facts directly.
2. Map dependent decisions and ask only questions whose prerequisites are settled.
3. Ask the available decision frontier together, with numbered questions and recommended answers.
4. Wait for answers, then recompute the frontier. Surface unresolved behavior rather than guessing.
5. Summarize the settled scope, exclusions, validation, and external authorization needs.
6. Obtain explicit shared-understanding confirmation before implementation or remote mutations.

During implementation, verify every promised surface.
For example, publishing requires a successful Pages deployment, not merely a successful local build.
If authorization blocks a remote operation, identify the blocker and preserve recoverable source information.

## Record vocabulary and decisions

Create a root `GLOSSARY.md` only when the interview resolves useful project-specific terminology.
Keep it to domain definitions, not implementation instructions or task notes.
Do not invent a glossary to fill a template.

Add a short, sequentially numbered ADR under `docs/adr/` only for a meaningful trade-off
that is costly to reverse and surprising without context.
State the decision and its reason in a few sentences.
Include rejected alternatives or consequences only when they help a later maintainer.

Keep interviews, agent instructions, and ADRs outside `site/src/content/`.
The [documentation-boundary decision](adr/0001-documentation-boundaries.md) explains why.
