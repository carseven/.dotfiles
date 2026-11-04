# Repository guidance

This repository contains machine-changing workstation installers. Inspect source and copied configuration before changing their behavior.
Use `./run --dry` for discovery and `./test` for shell behavior tests. Execute real installers only with explicit approval.

- When changing an exposed command or installer, update its public reference under `site/src/content/docs/reference/`. Document platform limits and side effects.
- When changing the website, deployment, or blog content, follow [website maintenance](docs/website.md). Keep maintainer documentation outside the public content collections.
- When the user requests a design interview, follow [agent workflows](docs/agent-workflow.md). Use upstream `grill-with-docs` explicitly, not for every task.
- When changing task tracking, follow [the migration procedure](docs/github-project-migration.md). Preserve source roadmap items until their issue and project membership are verified.

The root test runner covers `shell/tests/`, not personal-skill tests or website validation. Select the relevant validation surface.
