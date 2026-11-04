---
title: Agent skills
description: Install global skills, understand RTK integration, and explicitly invoke the documentation interview workflow.
---

## Install or refresh

Review `runs/skills/skills`, install Node with `npx` available, and preview the exact target:

```bash
./run --dry '^runs/skills/skills$'
./run '^runs/skills/skills$'
```

The installer uses the skills CLI to install **globally**, for GitHub Copilot and Claude Code.
It accepts installation prompts unattended and stops on command failures.
Rerunning it refreshes the selected skills from their sources.

## Sources

- All available skills from [mattpocock/skills](https://github.com/mattpocock/skills).
- ASD-STE100 for controlled-language writing.
- Five Caveman skills for terse output and related workflows.
- Cloudflare's security-audit skill.
- Personal skills in this repository: `pr-review`, `show-me`, `meeting-to-jira`, `training-coach`, and `route-planner`.

Upstream names and availability can change because the installer selects all Matt Pocock skills.
Inspect installation output rather than assuming a skill is already available in the active agent session.
Use the host agent's skill discovery or reload mechanism after installing.

## Interview with design documentation

The upstream workflow is named **`grill-with-docs`**.
Invoke it explicitly in an agent that supports the installed skill, for example:

```text
/grill-with-docs Design a safer installation workflow for this repository.
```

It combines `grilling` and `domain-modeling`.
The interview settles dependent design questions, sharpens project terms,
and records meaningful decisions when an ADR is justified.
It is not automatically required for routine fixes.

Repository-specific agent and maintainer guidance lives in the
[internal documentation](https://github.com/carseven/.dotfiles/tree/main/docs),
outside this public site.

## Global RTK changes

:::caution[Installation can change agent settings]
This installer does more than copy skills when `rtk` is available.
Review and back up existing global agent settings and hooks first.
:::

With RTK available, the script runs `rtk init --global --auto-patch`,
which updates Claude integration and writes RTK instructions.
It also overwrites `~/.copilot/hooks/rtk-rewrite.json` with a `PreToolUse` hook
that calls `rtk hook copilot`, uses `.` as its working directory, and has a five-second timeout.

Without RTK, the script reports that RTK integration was skipped and exits successfully.
That is not a failure of the preceding skill installation.
The script does not install RTK itself.

## Personal-skill dependencies

Personal skills can contain Python helpers or require external services.
Follow the selected skill's own instructions for those dependencies.
Their [source instructions](https://github.com/carseven/.dotfiles/tree/main/runs/skills/personal)
are authoritative for skill-specific workflows.
Root `./test` does not discover their implementation tests.
Do not publish service credentials or personal activity data in documentation or blog posts.
