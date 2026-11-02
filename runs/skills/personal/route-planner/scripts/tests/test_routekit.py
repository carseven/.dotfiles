import contextlib
import io
import os
import sys
import tempfile
import unittest
from types import SimpleNamespace
from unittest import mock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import routekit  # noqa: E402


def make_gpx(path, pts, with_ele=True):
    rows = []
    for lat, lon, ele in pts:
        inner = f"<ele>{ele}</ele>" if with_ele else ""
        rows.append(f'<trkpt lat="{lat}" lon="{lon}">{inner}</trkpt>')
    body = "\n".join(rows)
    with open(path, "w") as f:
        f.write('<gpx xmlns="http://www.topografix.com/GPX/1/1" version="1.1">'
                f"<trk><name>t</name><trkseg>{body}</trkseg></trk></gpx>")


def ramp(n=200, lat0=39.0, lon0=-0.3, dlat=0.0005, climb=1.0):
    """A straight north-going track: n points, 55 m apart, climbing `climb` m per point."""
    return [(lat0 + i * dlat, lon0, 100 + i * climb) for i in range(n)]


def run(fn, **kw):
    out = io.StringIO()
    with contextlib.redirect_stdout(out):
        fn(SimpleNamespace(**kw))
    return out.getvalue()


class GeometryTests(unittest.TestCase):
    def test_haversine_one_degree_latitude(self):
        self.assertAlmostEqual(routekit.haversine((0, 0, None), (1, 0, None)), 111195, delta=100)

    def test_ascent_ignores_noise_below_threshold(self):
        ele = [100, 102, 100, 102, 100, 110, 120]
        up, dn = routekit.ascent_descent(ele, 5)
        self.assertEqual((up, dn), (20, 0))

    def test_simplify_keeps_ends_and_limit(self):
        pts = [(39 + i * 0.0005, -0.3 + (0.0003 if i % 2 else 0), 0) for i in range(300)]
        out = routekit.simplify_to(pts, 17)
        self.assertLessEqual(len(out), 17)
        self.assertEqual(out[0], pts[0])
        self.assertEqual(out[-1], pts[-1])


class MapyUrlTests(unittest.TestCase):
    def test_lonlat_order_and_waypoints(self):
        url = routekit.mapy_url([(39.1, -0.3), (39.2, -0.2), (39.1, -0.3)], "foot_fast")
        self.assertIn("start=-0.300000,39.100000", url)
        self.assertIn("waypoints=-0.200000,39.200000", url)
        self.assertIn("routeType=foot_fast", url)

    def test_too_many_points_rejected(self):
        with self.assertRaises(SystemExit):
            routekit.mapy_url([(39, -0.3)] * 18, "foot_fast")


class GpxCommandTests(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.path = os.path.join(self.dir.name, "r.gpx")
        make_gpx(self.path, ramp())

    def tearDown(self):
        self.dir.cleanup()

    def test_stats_ramp(self):
        out = run(routekit.cmd_stats, gpx=self.path, threshold=5, pace=11, splits=True, json=False)
        self.assertIn("distance_km: 11.", out)
        self.assertIn("ascent_raw_m: 199", out)
        self.assertIn("ascent_m: 195", out)
        self.assertIn("km_effort: 13.", out)
        self.assertNotIn("\n   12:", out)

    def test_stats_without_elevation_warns(self):
        p = os.path.join(self.dir.name, "noele.gpx")
        make_gpx(p, ramp(), with_ele=False)
        out = run(routekit.cmd_stats, gpx=p, threshold=5, pace=11, splits=False, json=False)
        self.assertIn("no elevation", out)

    def test_compare_identical_is_fully_covered(self):
        out = run(routekit.cmd_compare, reference=self.path, candidate=self.path)
        self.assertIn('"within_25m": 1.0', out)

    def test_set_name(self):
        out_path = os.path.join(self.dir.name, "named.gpx")
        with contextlib.redirect_stderr(io.StringIO()):
            routekit.cmd_set_name(SimpleNamespace(input=self.path, output=out_path, name="Test 10 km"))
        with open(out_path) as f:
            self.assertIn("Test 10 km", f.read())

    def test_near_reports_reached_and_missed_points(self):
        # ramp runs north along lon -0.3 from lat 39.0; 0.0003 deg of longitude is about 26 m
        out = run(routekit.cmd_near, gpx=self.path, points="-0.2997,39.05;-0.29,39.05", within=50)
        lines = out.strip().splitlines()
        self.assertIn("| OK", lines[0])
        self.assertIn("km 5.", lines[0])
        self.assertIn("MISSED", lines[1])

    def test_surface_matches_way_tags(self):
        fake = {"elements": [{"geometry": [{"lat": 39.0, "lon": -0.3}, {"lat": 39.1, "lon": -0.3}],
                              "tags": {"highway": "path", "sac_scale": "mountain_hiking"}}]}
        with mock.patch.object(routekit, "overpass", return_value=fake):
            out = run(routekit.cmd_surface, gpx=self.path, snap=30, segments=True, min_run=200)
        self.assertIn("path | sac_scale=mountain_hiking", out)
        self.assertIn("T2", out)
        self.assertIn("km   0.0 - ", out)

    def test_surface_segments_keep_short_hard_runs(self):
        seq = [(i * 50.0, "path T2", False) for i in range(10)]
        seq += [(500.0, "path T3", True), (550.0, "path T3", True)]
        seq += [(600.0 + i * 50.0, "path T2", False) for i in range(10)]
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            routekit.print_segments(seq, cum_total=1100, min_run=200)
        out = buf.getvalue()
        self.assertEqual(out.count("path T2"), 2)
        self.assertIn("path T3", out)

    def test_surface_segments_merge_equal_runs_split_by_a_short_one(self):
        seq = [(i * 50.0, "path T2", False) for i in range(8)]
        seq += [(400.0, "road", False)]  # 50 m, hidden
        seq += [(450.0 + i * 50.0, "path T2", False) for i in range(8)]
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            routekit.print_segments(seq, cum_total=900, min_run=200)
        self.assertEqual(buf.getvalue().count("path T2"), 1)
        self.assertNotIn("road", buf.getvalue())

    def water_nodes(self):
        # the ramp runs north along lon -0.3; 0.0003 deg of longitude is about 26 m
        return {"elements": [
            {"lat": 39.05, "lon": -0.2997, "tags": {"natural": "spring", "name": "Font Near"}},
            {"lat": 39.08, "lon": -0.2997, "tags": {"amenity": "drinking_water", "name": "Tap"}},
            {"lat": 39.03, "lon": -0.2997, "tags": {"natural": "spring", "drinking_water": "no", "name": "Bad"}},
            {"lat": 39.05, "lon": -0.295, "tags": {"natural": "spring", "name": "Font Far"}}]}

    def test_water_lists_sources_on_route_and_gap(self):
        with mock.patch.object(routekit, "overpass", return_value=self.water_nodes()):
            out = run(routekit.cmd_water, gpx=self.path, max_dist=150, near=1000)
        self.assertIn("Font Near", out)
        self.assertIn("Tap", out)
        self.assertNotIn("WARNING", out)
        self.assertIn("longest stretch without water", out)
        self.assertIn("Font Far", out)  # about 430 m off: listed as a detour option
        self.assertNotIn("Bad |", out)
        self.assertIn("1 source(s) left out", out)

    def test_water_warns_when_nothing_on_route(self):
        with mock.patch.object(routekit, "overpass", return_value={"elements": []}):
            out = run(routekit.cmd_water, gpx=self.path, max_dist=150, near=1000)
        self.assertIn("WARNING: no water source", out)


class OverpassCommandTests(unittest.TestCase):
    def test_terrain_label(self):
        self.assertIn("T2", routekit.terrain_label({"highway": "path", "sac_scale": "mountain_hiking"}))
        self.assertEqual(routekit.terrain_label({"highway": "track", "tracktype": "grade2"}),
                         "gravel track, mostly firm")
        self.assertEqual(routekit.terrain_label({"highway": "footway", "surface": "asphalt"}), "paved path")
        self.assertEqual(routekit.terrain_label({"highway": "path"}), "path, difficulty not mapped")
        self.assertEqual(routekit.terrain_label({"highway": "residential"}), "road")
        self.assertEqual(routekit.terrain_label({"highway": "steps"}), "steps")
        self.assertEqual(routekit.terrain_label({"highway": "pedestrian"}), "pedestrian street")

    def test_nearest_on_track_gives_distance_and_position(self):
        pts = ramp(n=3, dlat=0.001)  # 111 m legs, going north
        xy = routekit.project(pts)
        cum = routekit.cumulative(pts)
        side = routekit.project([(pts[1][0], pts[1][1] + 0.0003)], sum(p[0] for p in pts) / 3)[0]
        dist, along = routekit.nearest_on_track(side, xy, cum)
        self.assertAlmostEqual(dist, 26, delta=3)
        self.assertAlmostEqual(along, cum[1], delta=3)

    def test_peaks_sorted_by_elevation(self):
        fake = {"elements": [
            {"lat": 39.0, "lon": -0.3, "tags": {"natural": "peak", "name": "Low", "ele": "300"}},
            {"lat": 39.1, "lon": -0.3, "tags": {"natural": "peak", "name": "High", "ele": "600"}}]}
        with mock.patch.object(routekit, "overpass", return_value=fake):
            out = run(routekit.cmd_peaks, lat=39, lon=-0.3, radius_km=5, min_ele=0)
        self.assertLess(out.index("High"), out.index("Low"))

    def test_chain_ways_joins_and_flips(self):
        a = [(0.0, 0.0, None), (0.001, 0.0, None)]
        b = [(0.002, 0.0, None), (0.001, 0.0, None)]  # reversed direction
        line, left = routekit.chain_ways([a, b])
        self.assertEqual(left, 0)
        self.assertEqual(line[0][0], 0.0)
        self.assertEqual(line[-1][0], 0.002)


if __name__ == "__main__":
    unittest.main()
