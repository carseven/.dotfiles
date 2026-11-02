# Mapy.com mechanics

Tested on 2 Nov 2026 with the Playwright browser tool. Mapy is a single-page app: use a browser, not `curl`.

## Route URL (no key, no login)

```
https://mapy.com/fnc/v1/route?mapset=outdoor&routeType=foot_fast&start=<lon>,<lat>&end=<lon>,<lat>&waypoints=<lon>,<lat>;<lon>,<lat>
```

- Order is **lon,lat**. `waypoints` is `;`-separated, at most 15. Start + 15 + end = 17 points.
- `routeType`: `foot_fast`, `foot_hiking`, `bike_mountain`, `bike_road`.
- `mapset=outdoor` shows marked hiking routes (red dashes) and contours.
- The page redirects to the planner (`/en/turisticka?planovani-trasy&rc=...`). The `rc` code is a compact encoding of the points. Two URLs with the same points give the same `rc`.
- Waypoints snap to the nearest routable way. Put them on paths, not on summits off the path.
- A loop is the same point as start and end.
- Source: developer.mapy.com "Mapy.cz URL" (`/fnc/v1`, free, no key).

### foot_fast against foot_hiking

The same 8 waypoints near Simat de la Valldigna gave **13.1 km** with `foot_fast` and **19.9 km** with `foot_hiking`. Hiking mode prefers marked routes and detours to them. Use `foot_fast` unless the line must follow a marked route. Compare both when unsure.

## Browser procedure

1. Navigate to the URL. Wait about 8 s for the route to draw.
2. Run the snippet below in the page (`browser_evaluate`). It waits for the summary, opens the elevation profile, reads the figures, exports the GPX and reads the share link.
3. Read the `### Result` block at the top of the tool output. The tool saves long outputs to a file, so read that file's head with `view` or `head`.
4. The download is reported under `### Downloads` as `.../export.gpx`. The name is reused, so copy the file before the next export.

```js
async () => {
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const text = e => e.innerText.trim().replace(/\s+/g, ' ');
  let summary;
  for (let i = 0; i < 60 && !summary; i++) {
    summary = [...document.querySelectorAll('h2,h3')].map(text).find(t => /[\d.]+\s*km/.test(t));
    if (!summary) await sleep(500);
  }
  const btn = l => [...document.querySelectorAll('button')].filter(b => text(b) === l);
  const profile = [...document.querySelectorAll('button')]
    .find(b => /Elevation profile/.test(b.innerText || b.getAttribute('aria-label') || ''));
  if (profile) profile.click();
  await sleep(2500);
  const elevation = [...document.querySelectorAll('li')].map(text)
    .filter(t => /^[\d.,]+ m( a\.s\.l\.)?$/.test(t));
  btn('Export')[0].click(); await sleep(1000);
  const d = btn('Export'); d[d.length - 1].click(); await sleep(2000);
  btn('Share')[0].click(); await sleep(2500);
  const link = [...document.querySelectorAll('input')].map(i => i.value)
    .find(v => /^https:\/\/mapy\.com\/s\//.test(v));
  return { summary, elevation, link };
}
```

Reading the result:

- `summary` is `h:mm h  km`. The time assumes 4 km/h on flat ground and ignores climbing. Do not use it. Use km-effort and the athlete's pace.
- `elevation` is `[max a.s.l., min a.s.l., ascent, descent]`. The thousands separator is a comma (`1,740 m`).
- Mapy's ascent is lower than the GPX sum: 650 m against 734 m raw and 717 m filtered on one route. Report both.
- The labels are English. The planner opens in English in a default Playwright browser. If the page is localized, adapt the label strings (`Export`, `Share`, `Elevation profile`).

## Visual check

`browser_take_screenshot` (viewport) shows the line over the outdoor map. Waypoints are numbered. Red dashes are marked routes. Take the screenshot **before** opening Share, because the dialog hides the map. A cookie banner at the bottom is harmless.

## Links to give the user

| Link                              | Use                                                                 |
| --------------------------------- | ------------------------------------------------------------------- |
| `fnc/v1/route?...` (long)         | Always rebuilds the route. Keep it in the note.                     |
| `https://mapy.com/s/<code>`       | Short link from the Share dialog. Works in a browser. `curl` gets 404 because the page needs JavaScript. |

## Failure modes

| Symptom                                       | Cause and fix                                                              |
| --------------------------------------------- | -------------------------------------------------------------------------- |
| Line leaves the intended trail                | Try `foot_hiking`, or add waypoints along the trail.                       |
| Odd detour through a road or canal            | A waypoint snapped to a different way. Move it onto the path or add one.   |
| No summary appears (likely a point off the network) | Move the waypoint closer to a path and reload.                       |
| Console errors `400` or `BLOCKED_BY_RESPONSE` | Seen on every load and harmless. Ignore them.                              |
| Evaluate fails with "execution context destroyed" | The page navigated during the script. Wait, then run it again.        |

## No browser tool

Give the user the long URL. Ask them to read km and ascent in the route panel, press Export (no login needed) and send the GPX path.

## Optional: REST API (not tested here)

The Mapy.com REST API has `GET https://api.mapy.com/v1/routing/route` (`start`, `end`, `waypoints`, `routeType`, `format=geojson`) and `GET /v1/elevation` (up to 256 positions). It needs an API key from developer.mapy.com. The free Basic tariff has 250,000 credits a month, and a route call costs 4 credits. Keep the key in an environment variable or the keychain. Never ask for it, print it, or store it in notes. The routing call returns geometry only, not ascent.
