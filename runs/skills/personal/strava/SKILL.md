---
name: strava
description: "Read the athlete's Strava activities, titles, descriptions, and Hevy strength logs through chrome-devtools in the athlete's logged-in browser. Use when a task needs recent runs, hikes, climbs, or gym sessions, treadmill elevation from titles, or strength loads and RPE from Hevy."
---

# Strava

Read the athlete's own Strava data in their logged-in browser. This skill is read-only.
Use the chrome-devtools tools (`chrome-devtools-*`). Do not use the integrated browser tools for Strava.

## Rules

- Never ask for, type, or store a username, password, or token. If Strava shows a login page, ask the athlete to sign in, then continue.
- The browser holds the athlete's other tabs. Do not read, navigate, or change them.
- Do not click Edit, Delete, Share, or any button that changes data.
- Close the tab you opened when you finish. Leave pages that you did not open.

## Steps

1. Open a new background tab: `chrome-devtools-new_page` with `background: true` and `https://www.strava.com/athlete/training`.
   Note its page ID from the returned page list.
2. If the page title is `Log In`, stop and ask the athlete to sign in. Read the page again after they confirm.
3. List activities with the JSON endpoint, using `chrome-devtools-evaluate_script` on that page.
   Snippets: [devtools.md](./references/devtools.md).
4. Filter the list to the period you need. Each page holds 20 activities. Request more pages until you reach the start date.
5. For strength sessions or notes, fetch each activity page and read the description (snippet in `devtools.md`).
6. Close your tab with `chrome-devtools-close_page`.
7. State the period you read. Say what you could not read. Do not invent missing values.

## What each field gives

| Field | Use |
|---|---|
| Title | Athletes often write slope, zone, or elevation here. Read it as the athlete's notation. A treadmill has no elevation field, so the title is the only source. Ask the athlete if the notation is unclear. |
| Distance, moving time, elevation | Summary values. Elevation is `0` for a treadmill unless the watch recorded it. |
| Description | Free text. Hevy writes the strength log here. |

## Hevy strength logs

The Hevy app posts a Strava activity for each strength session.
The description starts with `Logged with hevyapp.com`, then lists one block per exercise.

- With load: `Set 1: 40 kg x 10 @ 7 rpe` (kg × repetitions @ RPE).
- Bodyweight: `Set 1: 6 reps @ 7.5 rpe`.
- A line in quotes under an exercise name is a note from the athlete.
- A title that matches the routine name (for example `Torso`) is the Hevy activity. A generic title such as `Evening Weight Training` is the watch activity.

**One session appears twice.** The watch and Hevy each upload an activity with the same start time and a duration within about a minute.
Count it once. The Hevy activity holds exercises and loads. The watch activity holds heart rate.

To compare progress, match the same exercise across sessions. The same load at a lower RPE, or more repetitions at the same load, is improvement.

## Cautions

- The listing endpoint and page markup are not a public API. If a snippet returns nothing, take a snapshot (`chrome-devtools-take_snapshot`) and adjust the selector.
- Dates and times are in the athlete's local time zone and use the `M/D/YYYY` display format.
- Strava and Zepp can hold the same session. To merge, match by date and duration. See the `zepp` skill.
