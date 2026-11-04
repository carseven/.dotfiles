---
title: Root commands
description: Exact invocation, prerequisites, side effects, and exit behavior of install, run, and test.
---

These commands live at the repository root. Read their source before execution.
`run` and `test` locate the checkout themselves, so they also work when invoked by an absolute path.

## `install`

**Invocation:** `./install`. It implements no flags and ignores arguments.

**Requires:** Bash, Git, network access, and `curl` for the Homebrew download.
Platform operations additionally need Homebrew prerequisites or `sudo` and `apt-get`.

**Behavior:**

1. Clone `https://github.com/carseven/.dotfiles.git` into `$HOME/.dotfiles` if that directory is absent.
2. Otherwise, pull that checkout with `git pull --quiet`.
3. On macOS, execute the remote Homebrew installer and prepend `/opt/homebrew/bin` for this process.
4. On Linux, run `sudo apt-get update` and `sudo apt-get upgrade -y`.
5. Create `$HOME/dev` if needed.

It does not run the installer dispatcher.
It does not select your fork automatically.
Several paths are unquoted, and earlier failures can be masked by later commands.
There is no backup, rollback, or reliable aggregate failure status.

:::danger[Machine-changing bootstrap]
This command downloads executable code on macOS and upgrades packages on Linux.
Prefer the reviewed manual clone procedure in [Safe setup](../../guides/setup/).
:::

## `run`

**Invocation:** `./run [FILTER] [--dry]`.

**Requires:** Bash, `find`, `grep`, and each selected installer's own dependencies.
The dispatcher itself has no OS restriction.

```bash
./run --dry
./run --dry '^runs/vscode/vscode$'
./run '^runs/vscode/vscode$'
```

It changes to its own directory and discovers executable regular files one or two levels below `runs/`.
Discovery order is not sorted. It provides no dependency ordering.
Each installer runs as a separate process.

| Input or result | Meaning |
| --- | --- |
| `--dry` | Print the selected targets without executing child scripts |
| `FILTER` | Basic regular expression matched against the complete relative path |
| Multiple filters | Only the last non-`--dry` argument is retained |
| No filter | Select every discovered installer |
| No filter matches | Normally complete successfully without running a target |
| No installers discovered | Exit 1 |
| Child failure | Continue the loop; a later operation can mask the failure |
| `--help` or another unknown option | Treated as a filter, not an option |

Dry-run does not execute prerequisites, inspect target safety, or simulate file changes.
The local `log` and `execute` functions are not exported to child scripts.
There is no explicit interrupt trap or child-failure aggregation.

## `test`

**Invocation:** `./test`. Arguments are ignored.

**Requires:** Bash and `python3`. It has no OS-specific branch.

The script resolves the repository location and executes:

```bash
python3 -B -m unittest discover -s shell/tests -p 'test_*.py' -v
```

It exits 1 if it cannot resolve the directory or find Python.
Otherwise it returns the unittest process status.
`-B` prevents Python bytecode writes.

This command runs shell behavior tests, currently focused on `gh-approved`.
It does not install workstation packages, test clean installations, discover personal-skill tests,
or validate the Astro website.
