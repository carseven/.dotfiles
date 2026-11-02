---
name: route-planner
description: |-
  Route planner for hiking and trail running on foot, in any region. Asks the user for a concrete summit, mountain, trails and water sources, rebuilds the route in mapy.com, and delivers a measured GPX (saved in ~/Downloads by default) with a terrain report. Also recreates routes found on Wikiloc, Komoot, AllTrails, municipal sites or OpenStreetMap.
  Triggers: ruta, track, GPX, mapy, wikiloc, komoot, ruta circular, cima, senda, fuente, subir a una cima, salida de montaña, genera una ruta, recrear ruta, tipo de terreno, plan a hike to a summit.
license: MIT
metadata:
  author: Carles Serra Vendrell
  version: 2.0.0
  category: outdoors
---

# Route planner

Turn a request ("a loop to this summit by these trails, with a spring on the way", "recreate this Wikiloc route") into a **measured** GPX and a Mapy.com link. The method is the same in every region. Only sources and hazards change (`references/regions.md`).

`<skill_dir>` is this folder (normally `~/.agents/skills/route-planner`). The helper is `python3 <skill_dir>/scripts/routekit.py <command>` (standard library only, `--help` on each command).

Rules:

- **Measure, never estimate.** Every km, D+, D− and time in an answer comes from a GPX that Mapy produced and `routekit.py stats` measured.
- **Ask the user.** Take every fact about the user, the goal and the limits from the user's answers. Do not read the user's notes, plans or other files to fill gaps. A GPX the user points to is allowed.
- Mapy is the router and the deliverable. Other sources supply ideas, place names and reference figures.
- When no route meets the brief, show the closest ones with each gap stated.
- Ask and answer in the user's language.

## 1. Brief

Ask what is missing in one `ask_user` form. Do not offer example summits, trails or distances as options. Use free-text fields for places and numbers.

| Field    | Ask                                                                                                                     |
| -------- | ----------------------------------------------------------------------------------------------------------------------- |
| Start    | Town, trailhead or coordinates. How the user arrives (car, bus, on foot).                                               |
| Summit   | The exact name of each summit (cima) to reach. "None" is allowed.                                                       |
| Mountain | The mountain or range (montaña, sierra). Needed when there is no summit.                                                |
| Trails   | Names or marks of the trails (sendas, GR, PR, SL, local names) to use or avoid. "No preference" is allowed.             |
| Water    | Pass by a spring or fountain (fuente)? Options: at least one on the route, a named one, or "no, I carry all the water". |
| Shape    | Loop, out-and-back, or point-to-point (then ask how the user returns).                                                  |
| Activity | Hike, fast hike or trail run. The user's own pace in min per km-effort, if known.                                       |
| Limits   | Highest SAC grade accepted (T1, T2 or T3), exposure, steep descents, injuries.                                          |
| Date     | Date or season.                                                                                                         |
| Numbers  | Optional maximum distance, ascent or time. Free text. No suggested values.                                              |

The GPX goes to `~/Downloads`. Do not ask for the folder. Tell the user the path. Use another folder only when the user names one.

Done when the brief table has every field marked given, default or none, and the start plus at least one of summit, mountain or trails is known. Ask again when not.

**Km-effort** = km + D+/100. **Time** = km-effort × pace.

| Activity  | Default pace (min per km-effort)                                |
| --------- | --------------------------------------------------------------- |
| Hike      | 15                                                              |
| Fast hike | 12                                                              |
| Trail run | The user's recent figure. Ask. Flat pace is only a lower bound. |

The user's own pace always comes first.

When the user gives a time limit, the budget is `km-effort = minutes / pace`, so `km = km-effort − D+/100`.

Density in m of D+ per km: under 20 flat, 20-40 rolling, 40-70 hilly, 70-100 steep, over 100 vertical.

Feasibility: the ascent is at least the summit elevation minus the start elevation. For a limit on ascent, the highest point must be about 0.6-1.0 × D+ above the start. The rest of the D+ comes from ups and downs on the way (tested runs: 0.8 to 1.0 on simple loops, 0.6 on a circuit with a long traverse). Check elevations with `routekit.py elevation` before scouting.

## 2. Scout

Choose the branch:

- **Named summit:** `routekit.py geocode` gives its coordinates and elevation. Cross-check with `peaks`. List the marked trails near it with `routes`. Read published routes, their stats and comments (`references/sources.md`).
- **Named trail:** `routes` finds the OSM relation. `rel-gpx` writes it as a reference GPX.
- **Mountain only:** list peaks and places near the start (`geocode`, `peaks`, `routes`). Keep the summits that fit the feasibility range. Pick a loop that uses a different way up and down.
- **Named water source:** `find` it by name and use it as a waypoint.

Present 2-4 candidates (summit, trails, start, source, published km and D+, water, risks) and let the user choose with `ask_user`. Skip the choice when the user named one summit and its trails.

Done when each candidate has a start and ordered waypoints with `lon,lat` coordinates from `geocode`, `find`, or a reference GPX. The waypoints include the summit, a point on each named trail, and each wanted water source.

## 3. Build in Mapy

1. `routekit.py mapy-url --points "lon,lat;lon,lat;..."` (first = start, last = end), or `--gpx REF.gpx` to simplify a reference track to at most 17 points.
2. Open the URL in the browser, then read km and ascent, export the GPX and get the share link. Exact steps, the snippet and the pitfalls: `references/mapy.md`.
3. Copy the GPX out of the browser download folder at once. The file name `export.gpx` is reused.

Start with `foot_fast`. Try `foot_hiking` when the line must follow marked trails. It can be much longer.

## 4. Gate

Run `routekit.py stats <gpx> --pace <pace> --splits`, then check each item that the brief names.

- **Summit:** run `routekit.py near <gpx> "lon,lat"` with the summit coordinates. The closest approach is within 50 m and the line says OK. Do not compare the track's highest point with the OSM summit elevation: Mapy uses the SRTM model, which cuts sharp peaks (tested: summit 843 m in OSM, 811 m in the model, 810 m on the track). If the status is MISSED, the router stopped on a path below the top. Add a waypoint on the summit path and rebuild.
- **Trails:** the line sits on each named trail. Compare with the `rel-gpx` reference using `routekit.py compare REF.gpx NEW.gpx` (at least 95% of the wanted stretch within 50 m), or check the Mapy screenshot.
- **Water:** run `routekit.py water <gpx>`. If the user wanted a source and the command prints WARNING or lists none, **tell the user**. Offer the nearest source from the detour list as a waypoint, or a plan to carry all the water.
- **Numbers:** when the user gave limits, each one is inside ±10% (or the tolerance the user gave). Read D+ as **Mapy's ascent**. Report the GPX ascent next to it. It was 2-10% higher in the tested runs. Time and km-effort come from `stats`, which uses the GPX ascent, so they are the cautious values.
- **Recreated route with a reference GPX:** `routekit.py compare REF.gpx NEW.gpx` shows at least 95% of the reference within 50 m.
- **Recreated route without a reference GPX:** check the geometry on a Mapy screenshot (does it follow the named places in order?) and the stats against two or more published figures. Published D+ for one route varies by ±30% (GPS against DEM), so accept the spread.

On a fail, change the waypoints (table below) and rebuild. Stop after 4 rebuilds and report the gap.

| Gap                | Fix                                                               |
| ------------------ | ----------------------------------------------------------------- |
| D+ low             | Add a summit or a climbing detour, or start lower                 |
| D+ high            | Drop a summit, take the contouring path, start higher             |
| Distance short     | Add an out-and-back leg or make the loop wider                    |
| Distance long      | Cut a leg or take a shortcut                                      |
| Time over          | Cut km-effort and keep the pace fixed                             |
| Line off the trail | Move waypoints onto the path or add waypoints. Try `foot_hiking`  |
| No water on route  | Add the nearest source from the `water` detour list as a waypoint |

## 5. Terrain and hazards

Tell the user what terrain the route crosses. Method and legend tables: `references/mapy-legend.md`.

1. `routekit.py surface <gpx> --segments` gives the way type, SAC grade, surface and km range of each stretch. It needs Overpass, which is often at capacity. It can take about 2 minutes.
2. Open the plain Mapy outdoor map over the route and take a screenshot (the blue route line hides the base map). Read each stretch against the legend: line colour and dash pattern give the marked trail and its SAC grade. Dash styles give track, footpath or exposed footpath. Symbols give rock, scree or cliff.
3. Report for each km range: ground (road, track, footpath, rock or scree), hardest SAC grade and where, marked or not, stairs, exposed parts. Use the plain words in `references/mapy-legend.md`.
4. Flag a via ferrata, a protected segment or T4 and above. Do not plan it. Tell the user.
5. Go through the hazard list for the region in `references/regions.md`: season, closures, daylight, water, exposure, permits.
6. Apply the user's limits. Use the steep-descent share from `stats` (`share_descent_over_15pct`).

Mapy shows the surface and road-type chart only with Premium. Do not promise it.

Done when every risk and every terrain claim is checked against a named source or marked unverified. When Overpass fails and the screenshot is not readable, write "terrain unverified".

## 6. Deliver

1. Rename the track and save it in one step: `routekit.py set-name in.gpx ~/Downloads/<slug>.gpx "<Place> <km> km D+<m>"`. Watch apps show the name. The slug is lowercase words from the summit and place. If that file exists, add `-2`. Never overwrite another file.
2. Answer in the user's language with:
   - the result table: Mapy and GPX figures, km-effort, time at pace, max grade
   - the summit reached, the trails followed, and the water sources with their km (or the warning that there are none)
   - the terrain report from step 5
   - the Mapy short link, the GPX path, and the open risks
3. Write a note `<slug>.md` next to the GPX only when the user asks. It has frontmatter (`title`) and the sections: brief, result table, waypoints, terrain, water, Mapy links, sources with date, hazards and unverified items.

Mapy links: the long `fnc/v1/route` URL always rebuilds the route. The `mapy.com/s/...` short link is easier to share.

References, loaded on demand:

- `references/mapy.md`: URL, browser snippet, reading the numbers, failure modes.
- `references/mapy-legend.md`: line colours, dash patterns and symbols on the outdoor map, SAC grades, terrain report.
- `references/sources.md`: where to find routes, how to extract and recreate them, rights.
- `references/regions.md`: hazard checklists per region type.
- `references/examples.md`: tested runs with figures (evidence, not templates).
