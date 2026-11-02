# Terrain on the Mapy outdoor map

Use this file to tell the user what terrain a route crosses. Checked on 2 Nov 2026 against:

- Legend of the outdoor map: `https://mapy.com/en/turisticka?lgnd=1`. Each map type has its own legend (`/zakladni`, `/zimni`).
- Mapy help, map types: `https://help.mapy.com/map/map-types/`.
- Mapy help, route planning tools: `https://help.mapy.com/route-planning/tools/`.
- OpenStreetMap wiki, `sac_scale`: `https://wiki.openstreetmap.org/wiki/Key:sac_scale`.

Mapy drawings are copyright Seznam.cz. This file describes them in words. Do not copy the images.

## What the data is

- Czechia: Mapy editors draw the map. Rest of the world: OpenStreetMap. In Spain, France and Italy, Mapy shows OSM tags. `routekit.py surface` reads the same tags as text.
- The outdoor map has contour lines (5 m interval in Czechia, 10 m abroad) and shaded relief.
- Mapy ascent and descent are approximate. Abroad, the elevation model is SRTM with Aster. This is why Mapy ascent is lower than the GPX sum.
- The map can be wrong or old. Say so in the report.

## Marked hiking trails (legend rows, outdoor map)

| Drawing                                                  | Meaning                                                              |
| -------------------------------------------------------- | -------------------------------------------------------------------- |
| Solid bands in red, blue, green, yellow, with a signpost | Marked hiking trail. The colour is the waymark colour of that route. |
| Short dashes in the four colours                         | Local waymarking                                                     |
| Green dash-dot line with a name                          | Nature trail                                                         |
| Small coloured boxes (cross, dot, ...)                   | Waymark shapes in Germany, Hungary, Romania                          |
| Yellow shell on blue                                     | Way of St. James                                                     |

The colour does not give difficulty. Red and yellow lines both appear near Tavernes (Valencia). Read difficulty from the dash pattern below.

## Difficulty of a marked trail (SAC scale)

The legend has one row for difficulty. It shows the same coloured line in three patterns:

| Pattern of the coloured line | SAC grade              | OSM `sac_scale`                                | Plain meaning                                                                       |
| ---------------------------- | ---------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------- |
| Solid                        | T1, easy               | `strolling`, `hiking`                          | Cleared trail. Trainers are enough.                                                 |
| Dashed                       | T2-T3, mountain hiking | `mountain_hiking`, `demanding_mountain_hiking` | T2: stones, steep parts, hiking shoes. T3: exposed parts, scree, hands for balance. |
| Dotted                       | T4-T6, alpine hiking   | `alpine_hiking` and above                      | Hands needed. Exposed. Mountaineering experience.                                   |

Seen on 2 Nov 2026: the Les Creus loop above Tavernes is a red dashed line (T2-T3).
A dashed line covers both T2 and T3. Use `routekit.py surface` to separate them.

## Ways without marking (base lines)

| Drawing                           | Meaning                                        | Typical ground                   |
| --------------------------------- | ---------------------------------------------- | -------------------------------- |
| Thin solid line, single or double | Paved path                                     | Asphalt, concrete, paving stones |
| Long dashes                       | Forest or country road                         | Gravel or dirt track, wide       |
| Short dashes                      | Footpath                                       | Narrow trail                     |
| Dots                              | Difficult mountain footpath in exposed terrain | Rough, exposed                   |
| Very thin long dashes             | Forest ride                                    | Cleared strip in a forest        |
| Thick patterned band              | Boardwalk                                      | Planks                           |
| Stairs and passage symbols        | Stairs, passage                                | Steps                            |

## Protected and technical routes

| Drawing                                      | Meaning                                                                                                                       |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Dotted red line with a letter (A to F)       | Via ferrata. A easy, B moderately difficult, C difficult, D very difficult, E extremely difficult, F exceptionally difficult. |
| Green line with a ladder symbol and an arrow | Protected trail segment (fixed ropes, ladders, rungs). The arrow means one-way.                                               |

This skill flags a via ferrata or a protected segment. It does not plan them. Tell the user and stop.

## Ground and relief symbols

| Drawing                                 | Meaning                                          | What to tell the user                                 |
| --------------------------------------- | ------------------------------------------------ | ----------------------------------------------------- |
| Scallop marks and dots                  | Rocks, boulders, stone fields                    | Loose stone. Slow going.                              |
| Hatched edge with ticks                 | Quarry face, cliff                               | Drop. Check the path stays away from the edge.        |
| Grey texture                            | Bare rock, scree                                 | Loose or slippery ground                              |
| Dense contour lines                     | Steep slope                                      | Use the `stats` grade figures                         |
| Green fill                              | Forest, mountain pine                            | Shade. Fewer views.                                   |
| Thin solid blue line, wider for a river | Stream, river                                    | Water exists on the map. It is not a drinking source. |
| Pale blue dashes or dots                | Seasonal or intermittent stream, ephemeral water | Do not count on it for water                          |

## Restrictions that matter for walkers

The legend shows: roads with permanent access restriction, temporary entry restriction, borders of national parks and protected landscapes, quiet zones, natural park borders, protective zones of water tanks, military zone borders, game reserve fences. If the route crosses one, name it in the report and mark access as unverified.

## Planner events for walkers

Mapy marks these on the planned route (help page, route planning tools):

- Restrictions: closed or private area, military area, game reserve, nature protection area, water source protection area, closure.
- Events: via ferrata, train, ferry.
- Difficulty: "Difficult section" is about `sac_scale` 4. "Very difficult section" is `sac_scale` 5 and 6.

Mapy does not mark T2 and T3. No event does not mean an easy route.

## The planned route line hides the map

The planned route is a blue line on top of the map. On the Tavernes test route the line was solid in some parts and dashed in others. Mapy does not document this, so do not read terrain from it.
Open the plain outdoor map at the same place and read the base lines there:

```
https://mapy.com/en/turisticka?x=<lon>&y=<lat>&z=15
```

Use zoom 15 or 16. Dismiss the cookie banner (`Refuse`) first. Clicks sent from a script do not reach the map canvas, so read the drawing, not the pop-up.

## Premium

The elevation chart with gradients, surfaces and road types is part of Mapy Premium. A signed-in user without Premium has 5 free tries. A user who is not signed in sees a Premium message. The free route to the same facts is `routekit.py surface` (OSM tags) and the legend tables above.

## Terrain report

Make it with these steps, then put it in the note and in the answer:

1. Run `routekit.py surface <gpx> --segments`. It gives the share of each way type and the km range of each run.
2. Open the plain map at zoom 15 or 16 over the route. Take a screenshot. Read each stretch against the tables above.
3. When OSM and the drawing disagree, give the OSM `sac_scale` and say the map is not the same.
4. Write: type of ground for each km range (road, track, footpath, rock or scree), the hardest SAC grade and its km, marked or not marked, steps, exposed parts, rock symbols.
5. When Overpass fails and the screenshot is not readable, write "terrain unverified". Do not guess.

Words to use with the user, from the OSM wiki:

| Grade        | Words                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------ |
| T1           | Cleared trail, trainers are enough, orientation is easy                                          |
| T2           | Continuous trail, stones, steep parts. Hiking shoes. Some sure-footedness.                       |
| T3           | Boulders, exposed parts, possible scree, hands for balance. Good sure-footedness and navigation. |
| T4 and above | Hands needed. Alpine terrain. This skill only flags it.                                          |

`sac_scale` is subjective. Two mappers can differ by one grade. It describes technical difficulty, not altitude.
