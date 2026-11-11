---
name: zepp
description: "Read the athlete's Zepp Life (Amazfit) workouts, sleep, resting heart rate, stress, and body data from a local SQLite cache, and sync or configure that cache. Use when a task needs recent training, recovery, or heart-rate data from an Amazfit or Zepp watch."
---

# Zepp

A local CLI syncs Zepp Life data into a SQLite cache. Agents read the cache.
They do not call the Zepp cloud directly.

`<skill_dir>` is this folder, normally `~/.agents/skills/zepp`.
Run the CLI with `uv run --directory <skill_dir>/scripts python zepp_cli.py <command>`.

## Credential rule

An `apptoken` is a Zepp session credential.
Do not ask for it, read it, print it, or store it in chat, notes, logs, code, or settings.
The athlete configures it locally. Setup steps: [setup.md](./references/setup.md).

## Read data

1. Run `doctor`. It reports configuration, token, cache health, and synced data types.
2. If the task needs a period that the cache does not cover, ask for consent, then run `sync`.
   `sync` contacts the Zepp cloud and writes to the cache. `doctor` does not.
3. Read the cache read-only. Recipes, tables, and cautions: [cache.md](./references/cache.md).
4. State the date range you read, and say what is missing. Do not invent values.

## Commands

| Command | Use | Side effects |
|---|---|---|
| `doctor` | Check configuration and cache health | None |
| `configure` | Store region and token in the system keychain | Athlete runs it, not the agent |
| `sync` | Update the cache. Options: `--start-date`, `--end-date`, `--types`, `--force-full-sync`, `--json` | Network access, writes to the cache |
| `bruce-stages <workout_id>` | Split a cached treadmill workout into 3-minute modified-Bruce stages | Writes stage rows to the cache |
| `workout-probe` | Inspect the structure of the workout response | Network access |

## Limits

- The watch may miss sleep, night heart rate, or HRV on some days. Check coverage before you compute a baseline.
- Treadmill slope and elevation are not stored by the watch. Use the athlete's Strava titles for them (see the `strava` skill).
- Every data type has its own sync cursor. A recent `doctor` does not prove that every type is current.
- Tests: `uv run --directory <skill_dir>/scripts --all-groups pytest`.
