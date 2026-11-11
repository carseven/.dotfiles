# Strava DevTools snippets

Run these with `chrome-devtools-evaluate_script` on a Strava page of the athlete's logged-in session.
Pass the page ID. Set `waitForStableDom` to `false` because they only read data.
All of them ran successfully in a logged-in session. Strava can change its markup.

## List activities (JSON endpoint)

Returns 20 activities per page, newest first. Loop over `page` to go further back.

```js
async () => {
  const out = [];
  for (let page = 1; page <= 4; page++) {
    const r = await fetch(
      `/athlete/training_activities?page=${page}&per_page=20&order=start_date_local+DESC`,
      { credentials: 'include', headers: { 'X-Requested-With': 'XMLHttpRequest', Accept: 'application/json' } }
    );
    const j = await r.json();
    for (const a of (j.models || [])) {
      out.push([a.id, a.start_date, a.name, a.moving_time, a.distance, a.elevation_gain].join('|'));
    }
  }
  return out;
}
```

Fields seen: `id`, `start_date` (display text such as `Mon, 10/19/2026`), `name`, `moving_time` (`40:03`),
`distance` (kilometres as a number), `elevation_gain` (metres).
The sport is not in the fields above. Read it from the table (next snippet) or from the activity page when you need it.

## List activities (table fallback)

The training page shows the same data as a table. Each activity row is followed by a hidden edit row, so read only the first six cells.

```js
() => [...document.querySelectorAll('table tbody tr')].map(r => {
  const cells = [...r.querySelectorAll('td')].slice(0, 6)
    .map(td => td.innerText.trim().split('\n')[0].replace(/\s+/g, ' '));
  const link = r.querySelector('a[href*="/activities/"]');
  return cells.join('|') + '|' + (link ? link.getAttribute('href') : '');
}).join('\n')
```

Columns: sport, date, title, time, distance, elevation. Rows with a `|Title|Description|...` tail are the hidden edit rows. Ignore them.

## Read activity descriptions (Hevy logs and notes)

The description is not visible in the static list. Fetch each activity page and read `.activity-description .content`.

```js
async () => {
  const ids = ['REPLACE_WITH_ACTIVITY_ID'];
  const out = {};
  for (const id of ids) {
    const html = await (await fetch('/activities/' + id, { credentials: 'include' })).text();
    const doc = new DOMParser().parseFromString(html, 'text/html');
    const el = doc.querySelector('.activity-description .content');
    out[id] = el ? el.innerText.replace(/\n{2,}/g, '\n').trim() : '(no description)';
  }
  return out;
}
```

Keep the list of IDs short (about ten at a time) so the result stays small.
`(no description)` means the athlete wrote none. That is normal for climbing, hiking, and most runs.

## Summary stats of one activity

```js
async () => {
  const html = await (await fetch('/activities/REPLACE_WITH_ACTIVITY_ID', { credentials: 'include' })).text();
  const doc = new DOMParser().parseFromString(html, 'text/html');
  return [...doc.querySelectorAll('.inline-stats li, .secondary-stats li')]
    .map(e => e.innerText.replace(/\s+/g, ' ').trim()).slice(0, 12);
}
```
