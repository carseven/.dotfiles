---
name: route-planner
description: |-
  Route planner for hiking, trail running and mountain training in any region (Comunitat Valenciana, Pyrenees, Picos de Europa, Alps...). Interviews the user, finds or invents routes that fit a target distance, ascent, descent or time, rebuilds them in mapy.com and delivers a measured GPX plus a Mapy link. Also recreates routes found on Wikiloc, Komoot, all trails, etc.
  Triggers: ruta, track, GPX, mapy, wikiloc, komoot, ruta circular, salida de montaña, tirada larga, desnivel, D+, D-, "14 km y 700 m", genera una ruta, recrear ruta, route for X km and Y m gain.
license: MIT
metadata:
  author: Carles Serra Vendrell
  version: 1.0.0
  category: outdoors
---

# Route planner

Turn a request ("14 km and +700 m near Tavernes", "5 h of mountain from Lago Enol", "recreate this Wikiloc route") into a **measured** GPX and a Mapy.com link. The method is the same in every region. Only sources and hazards change (`references/regions.md`).

`<skill_dir>` is this folder (normally `~/.agents/skills/route-planner`). The helper is `python3 <skill_dir>/scripts/routekit.py <command>` (standard library only, `--help` on each command).

Rules:

- **Measure, never estimate.** Every km, D+, D− and time in an answer comes from a GPX that Mapy produced and `routekit.py stats` measured.
- Mapy is the router and the deliverable. Other sources supply ideas, place names and reference figures.
- When no route meets the brief, show the closest ones with each gap stated.

## 1. Brief

Load defaults, then ask only what is missing.

1. If `~/notes/notes/coach/plans/*/informe.md` exists (training-coach), read it (read-only) for the active plan's «Perfil del atleta»: pace in min per km-effort, uphill m/h, injury rules (for example knees: limit steep descents) and weekend availability. Without a plan, use the pace table below and ask.
2. Ask the gaps in one `ask_user` form:
   - **Area and start:** town, trailhead, or "I travel by car/bus".
   - **Targets:** any two of distance, D+, time. D− equals D+ on a loop.
   - **Shape:** loop, out-and-back, or point-to-point (needs transport back).
   - **Activity:** hike, fast hike, or trail run.
   - **Limits:** technicality (sac_scale T1-T3), exposure, steep-descent tolerance.
   - **Date or season.**
   - **Wishes:** summit, ridge, water, view, a named place.
   - **Tolerance** (default ±10% on each target) and **where to save** (default `~/Downloads`).

Done when a brief table holds start, shape, two targets, activity, limits and tolerance, each marked given or default.

**Km-effort** = km + D+/100. **Time** = km-effort × pace.

| Activity  | Default pace (min per km-effort)                                    |
| --------- | ------------------------------------------------------------------- |
| Hike      | 15                                                                  |
| Fast hike | 12                                                                  |
| Trail run | the athlete's recent figure (their flat pace is only a lower bound) |

The athlete's own pace from their plan always comes first.

Given a time, the budget is `km-effort = minutes / pace`, so `km = km-effort − D+/100`.

Density in m of D+ per km: under 20 flat, 20-40 rolling, 40-70 hilly, 70-100 steep, over 100 vertical.

Feasibility: the highest point must be about 0.6-1.0 × D+ above the start. The rest of the D+ comes from ups and downs on the way (tested runs: 0.8 to 1.0 on simple loops, 0.6 on a circuit with a long traverse). Check elevations with `routekit.py elevation` before scouting.

## 2. Scout

Choose the branch:

- **Named route or peak:** locate it, then read its stats, description and comments (`references/sources.md`).
- **Open brief:** peak-first. List peaks and places near the start (`geocode`, `peaks`, `routes`). Keep the summits that fit the feasibility range. Pick a loop shape that uses a different way up and down.

Present 2-4 candidates (name, source, published km and D+, why it is good, risks) and let the user choose with `ask_user`. Skip the choice when the user named one route.

Done when each candidate has a start and ordered waypoints with `lon,lat` coordinates from `geocode`, `find`, or a reference GPX.

## 3. Build in Mapy

1. `routekit.py mapy-url --points "lon,lat;lon,lat;..."` (first = start, last = end), or `--gpx REF.gpx` to simplify a reference track to at most 17 points.
2. Open the URL in the browser, then read km and ascent, export the GPX and get the share link. Exact steps, the snippet and the pitfalls: `references/mapy.md`.
3. Copy the GPX out of the browser download folder at once. The file name `export.gpx` is reused.

Start with `foot_fast`. Try `foot_hiking` when the line must follow marked trails. It can be much longer.

## 4. Gate

Run `routekit.py stats <gpx> --pace <pace> --splits`, then compare with the brief.

- Pass: every target in the brief (distance, D+, time) is inside the tolerance, with D+ read as **Mapy's ascent**. Report the GPX ascent next to it. It was 2-10% higher in the tested runs. Time and km-effort come from `stats`, which uses the GPX ascent, so they are the cautious values.
- Fail: change the waypoints (table below) and rebuild. Stop after 4 rebuilds and report the gap.
- Summit check: for each summit in the brief, the track's highest point near it should be within about 15 m of the summit's elevation. If it is lower, the router stopped on a path below the top. Add a waypoint on the summit path and rebuild.
- Recreated route with a reference GPX: `routekit.py compare REF.gpx NEW.gpx` shows at least 95% of the reference within 50 m.
- Recreated route without a reference GPX: check the geometry on a Mapy screenshot (does it follow the named places in order?) and the stats against two or more published figures. Published D+ for one route varies by ±30% (GPS against DEM), so accept the spread.

| Gap                | Fix                                                              |
| ------------------ | ---------------------------------------------------------------- |
| D+ low             | Add a summit or a climbing detour, or start lower                |
| D+ high            | Drop a summit, take the contouring path, start higher            |
| Distance short     | Add an out-and-back leg or make the loop wider                   |
| Distance long      | Cut a leg or take a shortcut                                     |
| Time over          | Cut km-effort and keep the pace fixed                            |
| Line off the trail | Move waypoints onto the path or add waypoints. Try `foot_hiking` |

## 5. Check the terrain

- `routekit.py surface <gpx>` gives path type, sac_scale and surface along the track. It needs Overpass, which is often at capacity. If it fails, say the terrain is unverified.
- Go through the hazard list for the region in `references/regions.md`: season, closures, daylight, water, exposure, permits.
- Apply the athlete's injury rules. Use the steep-descent share from `stats` (`share_descent_over_15pct`).

Done when every risk in the note is either checked against a named source or marked unverified.

## 6. Deliver

1. Rename the track: `routekit.py set-name in.gpx out.gpx "<Place> <km> km D+<m>"`. Watch apps show this name.
2. Save to `<out_dir>/<slug>/`. `<out_dir>` is the folder the user named in the brief, otherwise `~/Downloads`. Write `<slug>.gpx` and `<slug>.md`. The skill writes no routes into the Obsidian vault or any other notes folder.
3. The note is plain Markdown with these sections: brief, result table (Mapy and GPX figures, km-effort, time at pace, max grade), waypoints, Mapy links, sources with date, hazards and unverified items.
4. Answer in the user's language with the result table, the Mapy short link, the file paths and the open risks.

Mapy links: the long `fnc/v1/route` URL always rebuilds the route. The `mapy.com/s/...` short link is easier to share.

References, loaded on demand:

- `references/mapy.md`: URL, browser snippet, reading the numbers, failure modes.
- `references/sources.md`: where to find routes, how to extract and recreate them, rights.
- `references/regions.md`: hazard checklists per region type.
- `references/examples.md`: four tested runs (Valencia, Picos de Europa, Pyrenees, own route) with figures.
