import base64
import importlib.util
import json
import sys
from pathlib import Path

import pytest


@pytest.fixture
def cli(monkeypatch, tmp_path):
    module_path = Path(__file__).parents[1] / "zepp_cli.py"
    spec = importlib.util.spec_from_file_location("zepp_cli", module_path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    monkeypatch.setenv("RUNNING_COACH_ZEPP_DATA_DIR", str(tmp_path))
    return module


def test_configure_from_environment_stores_secret_outside_configuration(cli, monkeypatch, capsys):
    saved = {}
    monkeypatch.setenv("ZEPP_APP_TOKEN", "secret-token")
    monkeypatch.setattr(
        cli.keyring,
        "set_password",
        lambda service, account, token: saved.update(
            {"service": service, "account": account, "token": token}
        ),
    )

    exit_code = cli.main(["configure", "--from-env", "--region", "eu", "--user-id", "42", "--json"])

    assert exit_code == 0
    assert saved == {"service": "running-coach-zepp", "account": "42", "token": "secret-token"}
    assert json.loads((cli.app_directory() / "zepp.json").read_text()) == {
        "region": "eu",
        "user_id": "42",
    }
    assert "secret-token" not in capsys.readouterr().out


def test_doctor_reports_unconfigured_cache_without_creating_database(cli, capsys):
    exit_code = cli.main(["doctor", "--json"])

    assert exit_code == 2
    payload = json.loads(capsys.readouterr().out)
    assert payload["configured"] is False
    assert payload["database_exists"] is False
    assert not cli.database_path().exists()


def test_doctor_reports_healthy_initialized_database(cli, monkeypatch, capsys):
    configuration = cli.Configuration(region="eu", user_id="42")
    cli.write_configuration(configuration)
    cli.initialize_database(cli.database_path())
    monkeypatch.setattr(cli, "has_token", lambda _: True)

    exit_code = cli.main(["doctor", "--json"])

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["database_exists"] is True
    assert payload["database_healthy"] is True


def test_get_token_migrates_default_credential_after_user_id_discovery(cli, monkeypatch):
    credentials = {("running-coach-zepp", "default"): "secret-token"}

    monkeypatch.setattr(
        cli.keyring,
        "get_password",
        lambda service, account: credentials.get((service, account)),
    )
    monkeypatch.setattr(
        cli.keyring,
        "set_password",
        lambda service, account, token: credentials.__setitem__((service, account), token),
    )
    monkeypatch.setattr(
        cli.keyring,
        "delete_password",
        lambda service, account: credentials.pop((service, account)),
    )

    token = cli.get_token(cli.Configuration(region="eu", user_id="42"))

    assert token == "secret-token"
    assert credentials == {("running-coach-zepp", "42"): "secret-token"}


def test_nonnegative_float_discards_zepp_missing_value_sentinels(cli):
    assert cli.nonnegative_float(-1) is None
    assert cli.nonnegative_float("350") == 350


def test_sync_writes_all_supported_data_types_and_advances_cursors(cli, monkeypatch, capsys):
    cli.write_configuration(cli.Configuration(region="eu", user_id="42"))
    monkeypatch.setattr(cli.keyring, "get_password", lambda *_: "secret-token")

    class Response:
        def __init__(self, payload):
            self.payload = payload

        def raise_for_status(self):
            return None

        def json(self):
            return self.payload

    class Client:
        def __init__(self, **_):
            pass

        def __enter__(self):
            return self

        def __exit__(self, *_):
            return None

        def get(self, url, params):
            if "run/detail" in url:
                assert params["trackid"] == "run-1"
                assert params["source"] == "run.1.huami.com"
                return Response(
                    {
                        "data": {
                            "heart_rate": "2,80;,2;1,-1",
                            "speed": "0,1.5;1,2.0;1,2.5",
                            "currentDistance": "0,0;1,150;1,350",
                        }
                    }
                )
            if "weightRecords" in url:
                return Response(
                    {
                        "items": [
                            {
                                "id": "weight-1",
                                "generatedTime": 1704153600,
                                "summary": {"weight": 70.5, "fatRate": 15.2},
                            }
                        ]
                    }
                )
            if "history" in url:
                assert params["userid"] == "42"
                assert params["need_sub_data"] == 1
                return Response(
                    {
                        "data": {
                            "summary": [
                                {
                                    "trackid": "run-1",
                                    "type": 1,
                                    "sport_title": "Morning run",
                                    "start_time": 1704153600,
                                    "run_time": 1800,
                                    "dis": 5000,
                                    "calorie": 350,
                                    "avg_heart_rate": 142,
                                    "min_heart_rate": 108,
                                    "max_heart_rate": 171,
                                    "elevationGain": 220,
                                    "elevationLoss": 218,
                                    "source": "run.1.huami.com",
                                    "avg_pace": "0.36",
                                    "avg_frequency": "160.0",
                                    "rpe": 5,
                                    "exercise_load": 45,
                                    "heart_range": "60,95;1740,114",
                                    "exerciseTimeWithMillis": 1800500,
                                },
                                {
                                    "trackid": "boulder-1",
                                    "type": 184,
                                    "sport_title": "Bouldering",
                                    "start_time": 1704153600,
                                    "run_time": 5340,
                                    "dis": 0,
                                    "calorie": 400,
                                    "avg_heart_rate": 112,
                                    "min_heart_rate": 70,
                                    "max_heart_rate": 167,
                                },
                            ]
                        }
                    }
                )
            if params["query_type"] == "detail":
                return Response(
                    {
                        "data": [
                            {
                                "date_time": "2024-01-02",
                                "data_hr": base64.b64encode(bytes([0, 61, 255])).decode(),
                            }
                        ]
                    }
                )
            return Response(
                {
                    "data": [
                        {
                            "date_time": "2024-01-02",
                            "summary": {
                                "stp": {"ttl": 1000, "dis": 750, "cal": 100},
                                "slp": {"st": 1704153600, "ed": 1704182400, "rhr": 52},
                            },
                        }
                    ]
                }
            )

    monkeypatch.setattr(cli.httpx, "Client", Client)

    exit_code = cli.main(
        ["sync", "--start-date", "2024-01-01", "--end-date", "2024-01-02", "--json"]
    )

    assert exit_code == 0
    assert json.loads(capsys.readouterr().out)["failed_data_types"] == []
    with cli.sqlite3.connect(cli.database_path()) as connection:
        assert connection.execute("SELECT COUNT(*) FROM daily_activity").fetchone()[0] == 1
        assert connection.execute("SELECT COUNT(*) FROM sleep_sessions").fetchone()[0] == 1
        assert connection.execute("SELECT COUNT(*) FROM heart_rate_samples").fetchone()[0] == 2
        assert connection.execute("SELECT COUNT(*) FROM workouts").fetchone()[0] == 2
        assert connection.execute("SELECT calories_kcal FROM workouts").fetchone()[0] == 350
        assert (
            connection.execute(
                "SELECT workout_name FROM workouts WHERE workout_id = 'run-1'"
            ).fetchone()[0]
            == "Morning run"
        )
        assert connection.execute(
            "SELECT average_heart_rate_bpm, min_heart_rate_bpm, max_heart_rate_bpm, "
            "elevation_gain_m, elevation_loss_m FROM workouts WHERE workout_id = 'run-1'"
        ).fetchone() == (142.0, 108.0, 171.0, 2.2, 2.18)
        assert connection.execute(
            "SELECT activity_type FROM workouts WHERE workout_id = 'boulder-1'"
        ).fetchone()[0] == "bouldering"
        assert connection.execute("SELECT COUNT(*) FROM body_measurements").fetchone()[0] == 1
        assert connection.execute("SELECT COUNT(*) FROM sync_state").fetchone()[0] == 5
        assert connection.execute(
            "SELECT offset_s, heart_rate_bpm, speed_mps, distance_m FROM workout_samples "
            "WHERE workout_id = 'run-1' ORDER BY offset_s"
        ).fetchall() == [
            (0, None, 1.5, 0.0),
            (1, None, 2.0, 1.5),
            (2, 80, 2.5, 3.5),
            (3, 82, None, None),
            (4, 81, None, None),
        ]
        assert connection.execute(
            "SELECT duration_seconds, average_pace_s_per_km, average_cadence_spm, rpe, "
            "exercise_load, heart_zone_seconds, detail_synced_at IS NOT NULL "
            "FROM workouts WHERE workout_id = 'run-1'"
        ).fetchone() == (
            1800.5,
            360.0,
            160.0,
            5.0,
            45.0,
            '[{"from_bpm": 95, "seconds": 60}, {"from_bpm": 114, "seconds": 1740}]',
            1,
        )
        assert json.loads(
            connection.execute(
                "SELECT payload_json FROM raw_records "
                "WHERE data_type = 'workout_detail' AND source_record_id = 'run-1'"
            ).fetchone()[0]
        )["speed"] == "0,1.5;1,2.0;1,2.5"


def test_decode_series_handles_blank_gaps_and_deltas(cli):
    assert cli.decode_series("21,82;,-1;2,3;0,1", absolute=False) == [
        (21, 82.0),
        (22, 81.0),
        (24, 84.0),
        (24, 85.0),
    ]
    assert cli.decode_series("0,0.5;,0.7;2,0.0", absolute=True) == [
        (0, 0.5),
        (1, 0.7),
        (3, 0.0),
    ]
    assert cli.decode_series("", absolute=True) == []


def test_bruce_stages_summarize_three_minute_blocks(cli, capsys):
    database = cli.database_path()
    cli.initialize_database(database)
    with cli.sqlite3.connect(database) as connection:
        connection.execute(
            "INSERT INTO workouts (user_id, workout_id, local_date, activity_type, start_at, "
            "duration_minutes) VALUES ('42', 'w1', '2026-10-12', 'treadmill', "
            "'2026-10-12T16:28:03+00:00', 7)"
        )
        connection.executemany(
            "INSERT INTO workout_samples VALUES ('42', 'w1', ?, ?, ?, ?)",
            [(second, 100 + second // 10, 1.0, float(second)) for second in range(30, 420)],
        )

    exit_code = cli.main(["bruce-stages", "w1", "--json"])

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["start_min"] == 0.5
    first, second, third = payload["stages"]
    assert (first["incline_pct"], first["start_min"], first["complete"]) == (5, 0.5, True)
    assert first["max_heart_rate_bpm"] == 120
    assert first["distance_m"] == 209.0
    assert (second["incline_pct"], second["complete"]) == (10, True)
    assert (third["incline_pct"], third["complete"]) == (12, False)
    assert len(payload["stages"]) == 3
    assert [stage["completed_min"] for stage in payload["stages"]] == [3.0, 3.0, 0.48]

    assert cli.main(["bruce-stages", "w1", "--end-offset-minutes", "5", "--json"]) == 0
    stopped = json.loads(capsys.readouterr().out)["stages"]
    assert [stage["completed_min"] for stage in stopped] == [3.0, 1.5]
    assert [stage["complete"] for stage in stopped] == [True, False]