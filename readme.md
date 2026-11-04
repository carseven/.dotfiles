# .dotfiles

A personal macOS and Ubuntu-style workstation setup: installers, copied configuration, shell commands, and agent skills.
Review and adapt it before use. This is not a universal or unattended setup tool.

## Documentation

- [User documentation and blog](https://carseven.github.io/.dotfiles/) - available after the first successful Pages deployment.
- [Read the guides in source](./site/src/content/docs/index.md) while the site is not deployed.
- [Maintainer and agent documentation](./docs/readme.md), including blog authoring and design interviews.
- [GitHub issues](https://github.com/carseven/.dotfiles/issues).

## Start safely

Clone your own fork, inspect the selected installer, and back up affected files.
Configuration is copied, not symlinked. Installers can overwrite files, use sudo, download executable code, and change machine settings.

```bash
./run --dry
./run --dry '^runs/jq$'
./run '^runs/jq$'
```

The dry run only lists selected scripts. It does not simulate their effects.
Filters are regular expressions against paths, and installer order is not guaranteed.
The runner can mask child failures, so verify each result directly.
See [safe setup](./site/src/content/docs/guides/setup.md) before broader execution.

The root `install` script uses the original upstream and `$HOME/.dotfiles`, can bootstrap Homebrew or upgrade Linux packages,
and does **not** invoke `run`. Adapt it before using it with a fork.

## Validate without installing workstation packages

```bash
./run --dry
./test
```

`./test` needs Python 3 and discovers shell behavior tests only.
Website validation is separate. See [website maintenance](./docs/website.md).

## Skills

`./run '^runs/skills/skills$'` installs global skills for Copilot and Claude Code using `npx`.
It already selects all upstream Matt Pocock skills, including `grill-with-docs` when available.
RTK integration can change global agent settings and hooks.
Read the [skills reference](./site/src/content/docs/reference/skills.md) first.

## Manual configuration

- [Windows, WSL, and AutoHotKey](./doc/windows/readme.md)
- [Nuphy Keyboard](./doc/keyboards/nuphy-air60v2/readme.md)
- [Planck Keyboard](./doc/keyboards/planck/readme.md)

## Roadmap

The original list remains here until GitHub Project access is authorized and all eight migrated issues are verified in the project.
The [migration procedure](./docs/github-project-migration.md) defines that completion check.

- Automate setup keyboard shortcut for changing window focus instead of manually changing from Settings > Keyboard > Shortcuts > (Keyboard) Move focus to next window opt + x
- When laptop is connected to a monitor, automatically change the display settings to mirror the display instead of extending it. If the monitor brightness is removed, it mimics disconnecting the laptop display when connected to a monitor. maybe create an script. Settings > Display > Built-in Display > Mirror display
- Regression test from zero
- Capture control + c to exit the run script
- capture exit 1 from run script
- Setup docker to test clean installs (Linux and macos)
- Automate sudo, ask at the beginning of the script only.
- Prettify logs and error handling (Better show when script errors, maybe finish script execution?)

## Resources

- https://github.com/Gentleman-Programming/Gentleman.Dots
- https://github.com/ThePrimeagen/dev
- https://github.com/ThePrimeagen/.dotfiles
- https://github.com/joshmedeski/dotfiles
- https://github.com/typecraft-dev/dotfiles
