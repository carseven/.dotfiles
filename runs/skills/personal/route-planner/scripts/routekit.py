#!/usr/bin/env python3
"""routekit: measure GPX routes, rebuild them in Mapy.com and discover trails in OpenStreetMap.

Standard library only. Run `python3 routekit.py <command> --help` for each command.
"""
import argparse
import json
import math
import sys
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

EARTH_R = 6371000.0
OVERPASS_MIRRORS = [
    "https://overpass-api.de/api/interpreter",
    "https://overpass.private.coffee/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
]
NOMINATIM = "https://nominatim.openstreetmap.org/search"
OPENTOPODATA = "https://api.opentopodata.org/v1/{dataset}"
USER_AGENT = "route-planner-skill/1.0 (personal training use)"
MAPY_ROUTE_TYPES = ["foot_fast", "foot_hiking", "bike_mountain", "bike_road"]
MAPY_MAX_POINTS = 17  # start + 15 waypoints + end


# ---------------------------------------------------------------- geometry

def haversine(a, b):
    p1, p2 = math.radians(a[0]), math.radians(b[0])
    dl = math.radians(b[1] - a[1])
    h = math.sin((p2 - p1) / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * EARTH_R * math.asin(math.sqrt(h))


def project(points, lat0=None):
    """Return planar (x, y) metres for (lat, lon, ...) points."""
    lat0 = lat0 if lat0 is not None else sum(p[0] for p in points) / len(points)
    kx = math.cos(math.radians(lat0)) * 111320.0
    return [(p[1] * kx, p[0] * 110540.0) for p in points]


def seg_dist(p, a, b):
    ax, ay = a
    bx, by = b
    dx, dy = bx - ax, by - ay
    L = dx * dx + dy * dy
    t = 0.0 if L == 0 else max(0.0, min(1.0, ((p[0] - ax) * dx + (p[1] - ay) * dy) / L))
    return math.hypot(p[0] - (ax + t * dx), p[1] - (ay + t * dy))


def cumulative(points):
    out = [0.0]
    for a, b in zip(points, points[1:]):
        out.append(out[-1] + haversine(a, b))
    return out


def resample(points, step):
    """Points every `step` metres along the track, with linear elevation (None if missing)."""
    cum = cumulative(points)
    total = cum[-1]
    out, j = [], 0
    d = 0.0
    while d <= total:
        while j < len(points) - 2 and cum[j + 1] < d:
            j += 1
        seg = cum[j + 1] - cum[j]
        t = 0.0 if seg == 0 else (d - cum[j]) / seg
        a, b = points[j], points[j + 1]
        ele = None
        if a[2] is not None and b[2] is not None:
            ele = a[2] + t * (b[2] - a[2])
        out.append((a[0] + t * (b[0] - a[0]), a[1] + t * (b[1] - a[1]), ele, d))
        d += step
    return out


def douglas_peucker(xy, eps):
    keep = [False] * len(xy)
    keep[0] = keep[-1] = True
    stack = [(0, len(xy) - 1)]
    while stack:
        i, j = stack.pop()
        far, idx = 0.0, None
        for k in range(i + 1, j):
            d = seg_dist(xy[k], xy[i], xy[j])
            if d > far:
                far, idx = d, k
        if idx is not None and far > eps:
            keep[idx] = True
            stack.append((i, idx))
            stack.append((idx, j))
    return [i for i, k in enumerate(keep) if k]


# ---------------------------------------------------------------- GPX io

def read_gpx(path):
    root = ET.parse(path).getroot()
    pts = []
    for el in root.iter():
        tag = el.tag.split("}")[-1]
        if tag in ("trkpt", "rtept"):
            ele = None
            for c in el:
                if c.tag.split("}")[-1] == "ele" and c.text:
                    ele = float(c.text)
            pts.append((float(el.get("lat")), float(el.get("lon")), ele))
    if len(pts) < 2:
        sys.exit(f"error: {path} has fewer than 2 track points")
    return pts


def write_gpx(path, name, segments):
    lines = ['<?xml version="1.0" encoding="utf-8"?>',
             '<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1" creator="routekit">',
             f"<trk><name>{name}</name>"]
    for seg in segments:
        lines.append("<trkseg>")
        for p in seg:
            lines.append(f'<trkpt lat="{p[0]:.6f}" lon="{p[1]:.6f}"/>')
        lines.append("</trkseg>")
    lines.append("</trk></gpx>")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")


# ---------------------------------------------------------------- elevation maths

def ascent_descent(ele, threshold):
    """Hysteresis gain/loss: count a change only after it exceeds `threshold` metres."""
    up = dn = 0.0
    ref = ele[0]
    for x in ele[1:]:
        if x - ref >= threshold:
            up += x - ref
            ref = x
        elif ref - x >= threshold:
            dn += ref - x
            ref = x
    return up, dn


def fill_elevation(points):
    ele = [p[2] for p in points]
    if all(e is None for e in ele):
        return None
    last = next(e for e in ele if e is not None)
    out = []
    for e in ele:
        last = e if e is not None else last
        out.append(last)
    return out


# ---------------------------------------------------------------- stats

def cmd_stats(a):
    pts = read_gpx(a.gpx)
    cum = cumulative(pts)
    km = cum[-1] / 1000
    res = {"file": a.gpx, "points": len(pts), "distance_km": round(km, 2),
           "closed_loop": haversine(pts[0], pts[-1]) < 100}
    ele = fill_elevation(pts)
    if ele is None:
        res["warning"] = "no elevation data in this GPX; export it from Mapy.com to get elevation"
        return emit(res, a.json)
    raw_up = sum(max(0, y - x) for x, y in zip(ele, ele[1:]))
    up, dn = ascent_descent(ele, a.threshold)
    res.update({
        "ele_min_m": round(min(ele)), "ele_max_m": round(max(ele)),
        "ascent_raw_m": round(raw_up),
        "ascent_m": round(up), "descent_m": round(dn),
        "ascent_threshold_m": a.threshold,
        "m_per_km": round(up / km) if km else 0,
        "km_effort": round(km + up / 100, 1),
    })
    rs = resample(pts, 50)
    gr = []
    for i in range(len(rs) - 4):
        gr.append((rs[i + 4][2] - rs[i][2]) / 200.0 * 100)
    if gr:
        res["max_climb_grade_pct_200m"] = round(max(gr))
        res["max_descent_grade_pct_200m"] = round(min(gr))
        res["share_climb_over_15pct"] = round(sum(g > 15 for g in gr) / len(gr), 2)
        res["share_descent_over_15pct"] = round(sum(g < -15 for g in gr) / len(gr), 2)
    best, i = 0.0, 0
    for j in range(len(rs)):
        while rs[j][3] - rs[i][3] > 1000:
            i += 1
        best = max(best, rs[j][2] - rs[i][2])
    res["max_gain_in_1km_m"] = round(best)
    res["time_h_at_pace"] = round(res["km_effort"] * a.pace / 60, 2)
    res["pace_min_per_km_effort"] = a.pace
    if a.splits:
        splits, prev = [], 0
        for k in range(1, int(km) + 2):
            lo, hi = (k - 1) * 1000, min(k * 1000, cum[-1])
            if hi - lo < 100:
                continue  # skip a tiny leftover at the end of the track
            seg = [r for r in rs if lo <= r[3] <= hi]
            if len(seg) < 2:
                continue
            s_up, s_dn = ascent_descent([r[2] for r in seg], 2)
            splits.append({"km": k, "up_m": round(s_up), "down_m": round(s_dn),
                           "end_ele_m": round(seg[-1][2])})
        res["splits"] = splits
    emit(res, a.json)


def emit(res, as_json):
    if as_json:
        print(json.dumps(res, indent=2))
        return
    for k, v in res.items():
        if k == "splits":
            print("splits (km: +up / -down, end elevation):")
            for s in v:
                print(f"  {s['km']:>3}: +{s['up_m']:>4} / -{s['down_m']:>4}  {s['end_ele_m']} m")
        else:
            print(f"{k}: {v}")


# ---------------------------------------------------------------- Mapy URL

def mapy_url(points, route_type):
    """points: list of (lat, lon); first = start, last = end, middle = waypoints."""
    if len(points) < 2:
        sys.exit("error: need at least a start and an end point")
    if len(points) > MAPY_MAX_POINTS:
        sys.exit(f"error: Mapy accepts at most {MAPY_MAX_POINTS} points (start + 15 waypoints + end)")
    fmt = lambda p: f"{p[1]:.6f},{p[0]:.6f}"  # Mapy wants lon,lat
    url = ("https://mapy.com/fnc/v1/route?mapset=outdoor"
           f"&routeType={route_type}&start={fmt(points[0])}&end={fmt(points[-1])}")
    if len(points) > 2:
        url += "&waypoints=" + ";".join(fmt(p) for p in points[1:-1])
    return url


def parse_lonlat(text):
    out = []
    for chunk in text.replace("\n", ";").split(";"):
        chunk = chunk.strip()
        if chunk:
            lon, lat = chunk.split(",")[:2]
            out.append((float(lat), float(lon)))
    return out


def simplify_to(points, max_points):
    """Douglas-Peucker with the smallest tolerance that leaves <= max_points."""
    xy = project(points)
    lo, hi = 0.0, 5000.0
    best = douglas_peucker(xy, hi)
    for _ in range(30):
        mid = (lo + hi) / 2
        keep = douglas_peucker(xy, mid)
        if len(keep) <= max_points:
            best, hi = keep, mid
        else:
            lo = mid
    return [points[i] for i in best]


def cmd_mapy_url(a):
    if a.gpx:
        pts = simplify_to(read_gpx(a.gpx), a.max_points)
    elif a.points:
        pts = parse_lonlat(a.points)
    else:
        sys.exit("error: give --gpx FILE or --points 'lon,lat;lon,lat;...'")
    print(f"# {len(pts)} points (start, {max(len(pts) - 2, 0)} waypoints, end), type {a.type}", file=sys.stderr)
    for p in pts:
        print(f"# {p[1]:.6f},{p[0]:.6f}", file=sys.stderr)
    print(mapy_url(pts, a.type))


# ---------------------------------------------------------------- compare

def cmd_compare(a):
    ref, new = read_gpx(a.reference), read_gpx(a.candidate)
    lat0 = sum(p[0] for p in ref) / len(ref)

    def one_way(src, dst):
        src_xy = project([(p[0], p[1]) for p in resample(src, 50)], lat0)
        dst_xy = project(dst, lat0)
        dists = []
        for p in src_xy:
            dists.append(min(seg_dist(p, dst_xy[i], dst_xy[i + 1]) for i in range(len(dst_xy) - 1)))
        return dists

    def summary(d):
        return {"mean_m": round(sum(d) / len(d)), "max_m": round(max(d)),
                "within_25m": round(sum(x <= 25 for x in d) / len(d), 2),
                "within_50m": round(sum(x <= 50 for x in d) / len(d), 2)}

    res = {"reference_km": round(cumulative(ref)[-1] / 1000, 2),
           "candidate_km": round(cumulative(new)[-1] / 1000, 2),
           "reference_covered_by_candidate": summary(one_way(ref, new)),
           "candidate_covered_by_reference": summary(one_way(new, ref))}
    print(json.dumps(res, indent=2))


# ---------------------------------------------------------------- Overpass

def overpass(query, retries=2):
    data = urllib.parse.urlencode({"data": query}).encode()
    last = None
    for attempt in range(retries):
        for url in OVERPASS_MIRRORS:
            try:
                req = urllib.request.Request(url, data=data, headers={"User-Agent": USER_AGENT})
                with urllib.request.urlopen(req, timeout=30) as r:
                    return json.loads(r.read().decode())
            except Exception as e:  # public mirrors are often at capacity; try the next one
                last = e
                print(f"overpass: {url.split('/')[2]} failed ({e}); trying next", file=sys.stderr)
        time.sleep(4 * (attempt + 1))
    sys.exit(f"error: all Overpass mirrors failed ({last}). Use `geocode` for names and "
             "retry Overpass later; do not block the task on it.")


def get_json(url, params):
    req = urllib.request.Request(url + "?" + urllib.parse.urlencode(params), headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.loads(r.read().decode())


def cmd_geocode(a):
    params = {"q": a.query, "format": "jsonv2", "extratags": 1, "limit": a.limit}
    if a.near:
        lon, lat = (float(x) for x in a.near.split(","))
        d = a.radius_km / 111.0  # degrees of latitude; a rough box is enough to bias results
        params.update({"viewbox": f"{lon - d},{lat + d},{lon + d},{lat - d}", "bounded": 1})
    for r in get_json(NOMINATIM, params):
        ele = (r.get("extratags") or {}).get("ele", "-")
        print(f"{float(r['lon']):.6f},{float(r['lat']):.6f} | {r['display_name'][:80]} | "
              f"{r.get('category')}/{r.get('type')} | ele={ele}")


def cmd_elevation(a):
    pts = parse_lonlat(a.points)
    for i in range(0, len(pts), 100):
        chunk = pts[i:i + 100]
        loc = "|".join(f"{p[0]:.6f},{p[1]:.6f}" for p in chunk)
        res = get_json(OPENTOPODATA.format(dataset=a.dataset), {"locations": loc})
        for p, r in zip(chunk, res["results"]):
            ele = "n/a" if r["elevation"] is None else f"{r['elevation']:.0f} m"
            print(f"{p[1]:.6f},{p[0]:.6f} | {ele}")
        if i + 100 < len(pts):
            time.sleep(1.1)  # public instance allows one request per second


def cmd_set_name(a):
    ET.register_namespace("", "http://www.topografix.com/GPX/1/1")
    tree = ET.parse(a.input)
    root = tree.getroot()
    trk = next((el for el in root.iter() if el.tag.split("}")[-1] == "trk"), None)
    if trk is None:
        sys.exit("error: no <trk> in this GPX")
    name = next((c for c in trk if c.tag.split("}")[-1] == "name"), None)
    if name is None:
        ns = trk.tag[:trk.tag.index("}") + 1] if "}" in trk.tag else ""
        name = ET.Element(ns + "name")
        trk.insert(0, name)
    name.text = a.name
    tree.write(a.output, encoding="utf-8", xml_declaration=True)
    print(f"wrote {a.output} with track name '{a.name}'", file=sys.stderr)


def around(a):
    return f"(around:{int(a.radius_km * 1000)},{a.lat},{a.lon})"


def center(el):
    if el["type"] == "node":
        return el["lat"], el["lon"]
    c = el.get("center") or {}
    return c.get("lat"), c.get("lon")


def cmd_find(a):
    q = (f'[out:json][timeout:60];nwr["name"~"{a.pattern}",i]{around(a)};out center tags;')
    for el in overpass(q)["elements"]:
        t = el.get("tags", {})
        lat, lon = center(el)
        kind = t.get("natural") or t.get("highway") or t.get("route") or t.get("amenity") or t.get("historic") or "?"
        print(f"{el['type']}/{el['id']} | {t.get('name')} | {kind} | ele={t.get('ele', '-')} | {lon:.6f},{lat:.6f}")


def cmd_peaks(a):
    q = f'[out:json][timeout:60];node["natural"~"^(peak|saddle)$"]{around(a)};out body;'
    rows = []
    for el in overpass(q)["elements"]:
        t = el.get("tags", {})
        try:
            ele = float(t.get("ele", "").replace(",", "."))
        except ValueError:
            ele = None
        if ele is not None and ele < a.min_ele:
            continue
        rows.append((ele or 0, t.get("name", "(no name)"), t["natural"], el["lon"], el["lat"]))
    for ele, name, kind, lon, lat in sorted(rows, reverse=True):
        print(f"{name} | {kind} | {ele:.0f} m | {lon:.6f},{lat:.6f}")


def cmd_routes(a):
    q = f'[out:json][timeout:60];relation["route"~"^(hiking|foot|running)$"]{around(a)};out tags;'
    for el in overpass(q)["elements"]:
        t = el.get("tags", {})
        print(f"relation/{el['id']} | ref={t.get('ref', '-')} | {t.get('name', '-')} | "
              f"{t.get('network', '-')} | {t.get('distance', '-')} km | {t.get('osmc:symbol', '-')}")


def chain_ways(ways, gap=60.0):
    ways = [w[:] for w in ways if len(w) > 1]
    if not ways:
        return [], 0
    line = ways.pop(0)
    while ways:
        best = None
        for i, w in enumerate(ways):
            for side, end in (("tail", line[-1]), ("head", line[0])):
                for flip, w_end in ((False, w[0]), (True, w[-1])):
                    d = haversine(end, w_end)
                    if d <= gap and (best is None or d < best[0]):
                        best = (d, i, side, flip)
        if best is None:
            break
        _, i, side, flip = best
        w = ways.pop(i)
        if side == "tail":
            line = line + (w[::-1] if flip else w)
        else:
            line = (w if flip else w[::-1]) + line
    return line, len(ways)


def cmd_rel_gpx(a):
    q = f"[out:json][timeout:60];relation({a.relation});out geom;"
    els = overpass(q)["elements"]
    if not els:
        sys.exit("error: relation not found")
    ways = [[(g["lat"], g["lon"], None) for g in m["geometry"]]
            for m in els[0].get("members", []) if m["type"] == "way" and m.get("geometry")]
    line, left = chain_ways(ways)
    name = els[0].get("tags", {}).get("name", f"relation {a.relation}")
    write_gpx(a.output, name, [line])
    print(f"wrote {a.output}: {len(line)} points, {cumulative(line)[-1] / 1000:.1f} km", file=sys.stderr)
    if left:
        print(f"warning: {left} way segment(s) did not connect to the main chain and were left out; "
              "the relation may have gaps or branches", file=sys.stderr)


def cmd_surface(a):
    pts = read_gpx(a.gpx)
    lats, lons = [p[0] for p in pts], [p[1] for p in pts]
    pad = 0.0004
    bbox = f"{min(lats) - pad},{min(lons) - pad},{max(lats) + pad},{max(lons) + pad}"
    q = (f'[out:json][timeout:90];way["highway"]({bbox});out geom tags;')
    ways = overpass(q)["elements"]
    lat0 = sum(lats) / len(lats)
    way_xy = []
    for w in ways:
        g = w.get("geometry") or []
        if len(g) >= 2:
            way_xy.append((w.get("tags", {}), project([(p["lat"], p["lon"]) for p in g], lat0)))
    samples = resample(pts, 50)
    sample_xy = project([(s[0], s[1]) for s in samples], lat0)
    tally = {}
    for p in sample_xy:
        best, tags = a.snap, None
        for t, xy in way_xy:
            for i in range(len(xy) - 1):
                d = seg_dist(p, xy[i], xy[i + 1])
                if d < best:
                    best, tags = d, t
        key = "no match" if tags is None else (
            f"{tags.get('highway')} | sac_scale={tags.get('sac_scale', '-')} | surface={tags.get('surface', '-')}")
        tally[key] = tally.get(key, 0) + 1
    total = sum(tally.values())
    print(f"share of route by OSM way (sampled every 50 m, snap {a.snap} m):")
    for k, v in sorted(tally.items(), key=lambda kv: -kv[1]):
        print(f"  {v / total:5.0%}  {k}")
    print("note: sac_scale is missing on many OSM ways; '-' means unmapped, not easy.")


# ---------------------------------------------------------------- cli

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    s = sub.add_parser("stats", help="distance, ascent, descent, grades and time of a GPX")
    s.add_argument("gpx")
    s.add_argument("--threshold", type=float, default=5, help="ascent hysteresis in metres (default 5)")
    s.add_argument("--pace", type=float, default=11, help="minutes per km-effort (km + D+/100), default 11")
    s.add_argument("--splits", action="store_true", help="add a per-km table")
    s.add_argument("--json", action="store_true")
    s.set_defaults(fn=cmd_stats)

    s = sub.add_parser("mapy-url", help="build a Mapy.com route link from a GPX or explicit points")
    s.add_argument("--gpx", help="reference GPX, simplified to at most --max-points points")
    s.add_argument("--points", help="'lon,lat;lon,lat;...' first=start, last=end, middle=waypoints")
    s.add_argument("--type", default="foot_fast", choices=MAPY_ROUTE_TYPES)
    s.add_argument("--max-points", type=int, default=MAPY_MAX_POINTS)
    s.set_defaults(fn=cmd_mapy_url)

    s = sub.add_parser("compare", help="check how closely a candidate GPX follows a reference GPX")
    s.add_argument("reference")
    s.add_argument("candidate")
    s.set_defaults(fn=cmd_compare)

    s = sub.add_parser("geocode", help="name to lon,lat and OSM ele via Nominatim (no key, reliable)")
    s.add_argument("query", help="e.g. 'Puntal de Massalari, Tavernes de la Valldigna'")
    s.add_argument("--near", help="'lon,lat' to bias and limit results to a box around it")
    s.add_argument("--radius-km", type=float, default=15)
    s.add_argument("--limit", type=int, default=5)
    s.set_defaults(fn=cmd_geocode)

    s = sub.add_parser("elevation", help="ground elevation of points from a public DEM (OpenTopoData)")
    s.add_argument("points", help="'lon,lat;lon,lat;...'")
    s.add_argument("--dataset", default="eudem25m", help="eudem25m for Europe, srtm30m elsewhere")
    s.set_defaults(fn=cmd_elevation)

    s = sub.add_parser("set-name", help="rename the track inside a GPX (watch apps show this name)")
    s.add_argument("input")
    s.add_argument("output")
    s.add_argument("name")
    s.set_defaults(fn=cmd_set_name)

    for name, fn, helptext in (("find", cmd_find, "OSM features by name regex (Overpass)"),
                               ("peaks", cmd_peaks, "peaks and saddles with elevation"),
                               ("routes", cmd_routes, "waymarked hiking/running route relations")):
        s = sub.add_parser(name, help=helptext)
        s.add_argument("--lat", type=float, required=True)
        s.add_argument("--lon", type=float, required=True)
        s.add_argument("--radius-km", type=float, default=10)
        if name == "find":
            s.add_argument("pattern", help="name regex, e.g. 'Masalari|Massalari|Ratlla'")
        if name == "peaks":
            s.add_argument("--min-ele", type=float, default=0)
        s.set_defaults(fn=fn)

    s = sub.add_parser("rel-gpx", help="write an OSM route relation as a GPX (geometry only)")
    s.add_argument("relation", type=int)
    s.add_argument("output")
    s.set_defaults(fn=cmd_rel_gpx)

    s = sub.add_parser("surface", help="OSM path type, sac_scale and surface along a GPX")
    s.add_argument("gpx")
    s.add_argument("--snap", type=float, default=30, help="max metres from track to an OSM way")
    s.set_defaults(fn=cmd_surface)

    args = ap.parse_args()
    args.fn(args)


if __name__ == "__main__":
    main()
