# Zepp cache: how to read it

The cache is one SQLite file, `zepp.sqlite3`, in the data directory.
On macOS the default is `~/Library/Application Support/running-coach/zepp/`.
`RUNNING_COACH_ZEPP_DATA_DIR` overrides the directory.
The `running-coach` name is historical. It keeps existing tokens and caches working.

## Open it read-only

Use Python with a read-only URI.
In an agent session the `sqlite3` shell could not open this file, but this worked:

```python
import os, sqlite3
path = os.path.expanduser("~/Library/Application Support/running-coach/zepp/zepp.sqlite3")
db = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
rows = db.execute("select local_date, activity_type, duration_minutes from workouts limit 5").fetchall()
```

Never write to the cache directly. Use `sync` to update it.

## Tables

| Table | Key columns |
|---|---|
| `workouts` | `workout_id`, `local_date`, `activity_type`, `start_at`, `duration_minutes`, `distance_m`, `calories_kcal`, `workout_name`, `average_heart_rate_bpm`, `min_heart_rate_bpm`, `max_heart_rate_bpm`, `elevation_gain_m`, `elevation_loss_m`, `average_pace_s_per_km`, `average_cadence_spm`, `rpe`, `exercise_load`, `heart_zone_seconds` |
| `workout_samples` | `workout_id`, `offset_s`, `heart_rate_bpm`, `speed_mps`, `distance_m`. Present only for workouts with synced detail. |
| `workout_stages` | `workout_id`, `protocol`, `stage_index`, `incline_pct`, `protocol_speed_mph`, `start_offset_s`, `end_offset_s`, `average_heart_rate_bpm`, `max_heart_rate_bpm`, `end_heart_rate_bpm`. Written by `bruce-stages`. |
| `sleep_sessions` | `local_date`, `start_at`, `end_at`, `duration_minutes`, `time_asleep_minutes` |
| `heart_rate_samples` | `timestamp`, `sample_type`, `bpm`. Types seen: `passive` and `resting`. |
| `daily_activity` | `date`, `steps`, `distance_m`, `active_kcal` |
| `body_measurements` | `timestamp`, `weight_kg`, `body_fat_pct` |
| `stress_daily` | `local_date`, `avg_stress`, `min_stress`, `max_stress`, and time-share columns |
| `sync_state` | Per data type: `last_success_at`, `records_count`. Use it to check freshness. |

## Cautions

- **Activity types are mixed.** Some rows use words (`running`, `treadmill`, `walking`, `bouldering`).
  Others use numeric codes (for example `52`, `22`, `13`, `225`). The cache has no code-to-name table.
  Infer a code from duration, distance, and heart rate, or confirm it with the athlete or Strava.
  Do not guess silently.
- **Duplicates.** A gym session can exist once in Zepp and once more in Strava (from the Hevy app).
  Match by date and duration before you add totals.
- **Gaps.** Check `sync_state` and the date range before you compute weekly totals or baselines.
- **Resting heart rate.** Use the `resting` samples or the athlete's morning value, not the `passive` minimum.
- **Elevation.** Treadmill rows carry no elevation. Outdoor rows may have `elevation_gain_m`.
- **Heart-rate zones.** The cache has a `heart_zone_seconds` column with the watch's time-in-zone data. I did not verify its format.
  The watch zones may differ from the athlete's own zones. Recompute time in zone from `workout_samples` instead.
