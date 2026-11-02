# Finding routes and recreating them

## Search

`web_fetch` fails on search engines (DuckDuckGo shows a bot check, Bing returns noise). Use the browser tool:

1. Navigate to `https://www.bing.com/search?q=<query>&setlang=es`.
2. Unwrap the result links. Bing wraps them in redirects whose `u` parameter holds the target as `a1` + base64:

```js
() => [...document.querySelectorAll('li.b_algo h2 a')].slice(0, 8).map(a => {
  const u = new URL(a.href).searchParams.get('u');
  let url = a.href;
  try { url = atob(u.slice(2).replace(/-/g, '+').replace(/_/g, '/')); } catch (e) {}
  return a.innerText.slice(0, 90) + ' | ' + url;
})
```

3. Open the best pages with `web_fetch` (public Wikiloc and municipal pages work).

Queries that worked: `ruta pic del masalari tavernes de la valldigna wikiloc` and `ruta circular Ordesa Pradera Cola de Caballo Faja de Pelay wikiloc`. Pattern: `ruta <peak or circuit> <town> wikiloc`. Add `gpx`, `trail`, `circular` or the local language (ca, fr, en) when results are thin. Spellings differ (`Masalari`, `Massalari`): try both.

## Sources

| Source                                 | Gives                                           | Geometry or GPX                  | Notes                                                              |
| -------------------------------------- | ----------------------------------------------- | -------------------------------- | ------------------------------------------------------------------ |
| Wikiloc (any language subdomain)       | km, D+, description, waypoints, comments        | GPX needs login                  | Public pages are enough for stats and text. Search pages return 403 to scripts. Read the comments: they report closed gates and reroutes. |
| Municipal and tourism sites            | Official circuit, often with a GPX              | Often downloadable               | Search for the municipality name + `ruta`. The Tavernes town hall page for Pico del Massalari appeared in results but did not load on 2 Nov 2026. |
| Regional federations (FEDME, FEMECV)   | Homologated GR, PR and SL routes                | Varies                           | Marked routes are the safest line to follow.                       |
| National park sites                    | Official routes, closures, quotas, buses        | Rarely                           | Needed for Ordesa, Picos de Europa and other parks.                |
| OpenStreetMap                          | Route relations, peaks with `ele`, path tags, springs and fountains | `routekit.py rel-gpx`, `surface`, `water` | Open data (ODbL). Needs Overpass, which is often at capacity. `routekit.py` tries four public mirrors and a run can take up to 3 minutes. |
| Nominatim (`routekit.py geocode`)      | Name to `lon,lat`, `ele` of peaks               | Points only                      | Most reliable keyless lookup. One request per second.              |
| Komoot, AllTrails, Strava              | Stats and previews                              | Login or paywall                 | Use for ideas. Ask the user for a GPX they can download.           |
| Hikr, Camptocamp, Visorando            | Mountain routes with descriptions (Alps, Pyrenees, France) | Often GPX             | Check the licence of each GPX.                                     |
| Waymarked Trails (website)             | Marked routes by `ref` (GR 11, PR-CV ...)       | Check the site for export        | The search API (`hiking.waymarkedtrails.org/api/v1/list/search`) answered. The area and GPX endpoints were not confirmed. |
| Mapy outdoor map (screenshot)          | Marked trails, SAC difficulty by dash pattern, ground symbols, contours, peak names | View only | Good for terrain and for choosing a loop shape when Overpass is down. Legend: `mapy-legend.md`. |

## Extract from a source page

Write down: distance, D+, shape (loop, out-and-back), start, the ordered named places, difficulty, recording date, comments about closures or gates, and the number of downloads or ratings. Keep the URL for the credits in the note.

## Recreate a route

Pick the best method available:

| Method | Input                          | Steps                                                                                         |
| ------ | ------------------------------ | --------------------------------------------------------------------------------------------- |
| A      | A GPX the user has             | `routekit.py mapy-url --gpx REF.gpx`, build in Mapy, then `compare REF.gpx NEW.gpx`.          |
| B      | An OSM route relation          | `routekit.py rel-gpx <id> ref.gpx`, then method A. The GPX has geometry only. Mapy adds elevation. |
| C      | Only a description             | `routekit.py geocode "<place>" --near lon,lat` for each named place in order, then `mapy-url --points`. |

After building, run the Gate in `SKILL.md`. Method C reproduces the *idea* of the route. Say so in the note.

## Rights and etiquette

- Do not bypass logins or paywalls. Ask the user for a GPX they already have access to.
- Do not republish a source GPX. Rebuild the route from waypoints and credit the source.
- Respect Nominatim (1 request per second, identify the app) and Overpass (back off when it is at capacity).
