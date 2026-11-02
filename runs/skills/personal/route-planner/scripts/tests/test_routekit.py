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

    def test_surface_matches_way_tags(self):
        fake = {"elements": [{"geometry": [{"lat": 39.0, "lon": -0.3}, {"lat": 39.1, "lon": -0.3}],
                              "tags": {"highway": "path", "sac_scale": "mountain_hiking"}}]}
        with mock.patch.object(routekit, "overpass", return_value=fake):
            out = run(routekit.cmd_surface, gpx=self.path, snap=30)
        self.assertIn("path | sac_scale=mountain_hiking", out)


class OverpassCommandTests(unittest.TestCase):
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
