# Tested examples (2 Nov 2026)

Four runs of the workflow in different regions. Coordinates are `lon,lat`. "Mapy" is the ascent Mapy shows. "GPX" is `routekit.py stats` on the exported file (5 m hysteresis). Km-effort and time come from the GPX ascent. Where no GPX was saved (marked `~`), they use Mapy's ascent. Replay any run by opening its URL.

## 1. Comunitat Valenciana: brief met

**Brief:** loop from Tavernes de la Valldigna, 14 km, +700 m, with Pic del Masalari and Les Creus. Tolerance ±10%: 12.6-15.4 km and 630-770 m. Pace 11 min per km-effort (the athlete's plan).

**Points (found with `geocode`):** town centre `-0.267881,39.071622` (15 m), les Creus `-0.278569,39.079743` (540 m), Font de la Sangonera `-0.291536,39.086750`, Puntal de Massalari `-0.297559,39.095534` (599 m), la Ratlla `-0.310859,39.103127` (625 m).

| Variant                                  | km   | Mapy D+ | GPX D+ | Max   | Km-effort | Time at 11 |
| ---------------------------------------- | ---- | ------- | ------ | ----- | --------- | ---------- |
| A: Creus, Sangonera, Massalari           | 11.8 | +698    | n/a    | 578 m | ~18.8     | ~3.4 h     |
| **B: A plus la Ratlla**                  | 14.9 | **+747**| 765    | 600 m | 22.5      | 4.1 h      |

B passes the Gate on km and D+ (inside tolerance). It is a loop on marked trails (red dashes on the outdoor map near Les Creus) with 51 m of D+ per km. 12% of the route climbs more than 15% (200 m windows) and 11% descends more than 15%. Terrain not checked: Overpass was down. **Summit check fails narrowly:** the track peaks at 600 m while OSM lists la Ratlla at 625 m, so the track may stop short of the top. The note flags it for a map check.

```
https://mapy.com/fnc/v1/route?mapset=outdoor&routeType=foot_fast&start=-0.267881,39.071622&end=-0.267881,39.071622&waypoints=-0.278569,39.079743;-0.291536,39.086750;-0.297559,39.095534;-0.310859,39.103127
```

Published references (Wikiloc, for the note's sources): 15.0 km +927 m (via PR-V 38, 39 and 40, with Ratlla and Les Creus), 14.45 km +715 m (Senda Amoladors), 16.5 km +889 m, 20.0 km +1058 m (with Ouet d'Alzira). Geometry was not available, so this is a rebuild of the idea (method C).

## 2. Picos de Europa: no route fits, report the trade-off

**Brief:** hike from Lago Enol, about 5 h, +700 m. Pace 15 min per km-effort. Budget: 20 km-effort, which is about 13 km at +700 m.

**Points:** Lago Enol `-4.991615,43.271957`, Vegarredonda `-4.992299,43.233648`, Mirador de Ordiales `-5.012043,43.224289` (1,750 m).

| Route                      | km   | Mapy D+ | Max      | Km-effort | Time at 15 |
| -------------------------- | ---- | ------- | -------- | --------- | ---------- |
| Enol, Ordiales, Enol       | 19.9 | +704    | 1,740 m  | 27.4      | 6.9 h      |
| Enol, Vegarredonda, Enol   | 13.7 | +433    | 1,485 m  | ~18.0     | ~4.5 h     |

Adding Vegarredonda as a waypoint to the Ordiales route changed nothing: it is on the shortest path (9.9 km each way). **Result:** +700 m needs about 6.9 h, and 5 h gives +433 m. The skill reports both and lets the user choose. It does not trim the numbers.

```
https://mapy.com/fnc/v1/route?mapset=outdoor&routeType=foot_fast&start=-4.991615,43.271957&end=-4.991615,43.271957&waypoints=-5.012043,43.224289
```

## 3. Pyrenees: recreate a published classic

**Brief:** the Ordesa circuit Pradera de Ordesa, Cola de Caballo, Faja de Pelay, Senda de los Cazadores. Published by Wikiloc: 17.4 km +817 m (track 18622449) and 21.1 km +1,251 m (track 28418941).

**Points:** Pradera `-0.059732,42.649233`, Senda a la Cola de Caballo `-0.034697,42.640316`, Cola de Caballo `0.015393,42.650957`, Puente de Soaso `0.015555,42.649814`, Mirador de Calcilarruego `-0.054122,42.641415`.

**Result:** 19.3 km, Mapy +1,101 m, GPX +1,167 m, from 1,320 to 1,980 m, km-effort 31 (7.7 h at 15). The screenshot shows the valley path (GR 11) up and the Faja de Pelay back, as intended. The two published tracks differ by 50% in D+, and the rebuild sits between them. **Lesson:** published D+ is a range. Check geometry visually and against start and top elevations. The route has descents steeper than 15% over 13% of its length, which matters for knees.

```
https://mapy.com/fnc/v1/route?mapset=outdoor&routeType=foot_fast&start=-0.059732,42.649233&end=-0.059732,42.649233&waypoints=-0.034697,42.640316;0.015393,42.650957;0.015555,42.649814;-0.054122,42.641415
```

## 4. Own route: round trip through 17 points

The athlete's Simat de la Valldigna route (13.06 km, 60-736 m, Mapy +650 m, GPX +717 m, 1,223 points) was reduced with `mapy-url --gpx` to 17 points, rebuilt in Mapy, exported and checked:

```
compare original.gpx rebuilt.gpx
reference covered by candidate: 99% within 25 m, mean 1 m, max 90 m
rebuilt: 12.85 km, Mapy +639 m, GPX +704 m
```

The 90 m maximum is the turn-around at the summit, where the simplification dropped a point. Add a waypoint at the turn if it matters.

The same 8 waypoints with `foot_hiking` gave 19.9 km instead of 13.1 km. See `mapy.md`.
