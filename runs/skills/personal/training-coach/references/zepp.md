# Zepp Life local data

The coach can use workouts, sleep, heart rate, daily activity, and body measurements through a local SQLite cache managed by the Zepp CLI bundled with this skill (`scripts/zepp`). Agents read that cache during normal coaching workflows, so they do not contact the cloud each time.

`<skill_dir>` is the folder of this skill, normally `~/.agents/skills/training-coach`. The cache and the app data live in the user data directory (`RUNNING_COACH_ZEPP_DATA_DIR` overrides it), not in the skill folder. The data directory, the Keychain service and the variable keep the old `running-coach` name so that an existing token and cache keep working. A reinstall of the skill does not delete them.

## Install

Install [uv](https://docs.astral.sh/uv/), then initialize the local Zepp CLI environment:

```bash
uv sync --directory <skill_dir>/scripts/zepp --all-groups
```

## Get and store the appToken

An `apptoken` is a sensitive Zepp Life session credential. Do not paste it into chat, commits, plans, the athlete profile, or VS Code settings.

1. Open `https://user.huami.com/privacy2/index.html` and sign in to Zepp Life.
2. Open browser DevTools. In Chrome or Edge on macOS, use `Option` + `Command` + `I`; in Safari, enable the Develop menu in Settings first, then use the same shortcut.
3. In **Application** (Chrome/Edge) or **Storage** (Safari), open the `user.huami.com` cookies and copy the value named `apptoken`.
4. Run this command and paste it only into the hidden terminal prompt:

```bash
uv run --directory <skill_dir>/scripts/zepp python zepp_cli.py configure --region eu
uv run --directory <skill_dir>/scripts/zepp python zepp_cli.py doctor
```

This is the recommended workflow. The CLI stores the token in macOS Keychain, avoiding shell history and workspace files. Use a different region only if the account requires it.

For simple local automation, set `ZEPP_APP_TOKEN` in an ignored `.env` file and run:

```bash
uv run --directory <skill_dir>/scripts/zepp python zepp_cli.py configure --from-env
```

The `.env` option is less secure than Keychain. It must not be committed or shared. If it is exposed, revoke or replace the Zepp session and configure a new token.

## Sync and use cached data

```bash
# First sync fetches the prior 365 days. Later syncs use upstream cursors.
uv run --directory <skill_dir>/scripts/zepp python zepp_cli.py sync

# Check configuration and cache health.
uv run --directory <skill_dir>/scripts/zepp python zepp_cli.py doctor
```
