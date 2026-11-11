# Running targets and time trials

Use this file when the athlete names a race time, a pace, or a running goal. The methods here are inferences from a race-prediction model. They are not from the four books, except where a book is named.

## 1. Read the athlete's runs

1. Get recent runs with the `zepp` and `strava` skills: distance, time, average heart rate, and surface.
2. Compute pace as time ÷ distance. Do not use the watch's moving pace without checking it.
3. Classify each run. A steady run near the athlete's aerobic threshold heart rate is an easy effort, not a race effort.
   Its pace does not predict a race pace. It only shows endurance.
4. Note weekly volume and the longest recent run. Low volume limits the target.

## 2. Estimate a realistic time

Use the Daniels–Gilbert model. `v` is speed in m/min and `t` is time in minutes.

```text
VO2 cost = -4.60 + 0.182258 v + 0.000104 v²
fraction = 0.8 + 0.1894393 e^(-0.012778 t) + 0.2989558 e^(-0.1932605 t)
VDOT     = VO2 cost / fraction
```

Solve for `t` at a distance, with a given VDOT, to get a race time. Compute it, do not recall it.

| VDOT | Half marathon | Pace |
|---|---|---|
| 34 | about 2:06 | 6:00/km |
| 36 | about 2:00 | 5:45/km |
| 38 | 1:55:51 | 5:29/km |
| 40 | 1:50:53 | 5:15/km |
| 42.4 | 1:45:30 | 5:00/km |
| 46 | 1:38:21 | 4:39/km |

- Several estimates of fitness can disagree (a watch value, a lab protocol, a field test). Show the range.
- The model assumes training for the distance. With about three runs a week, treat the result as an upper bound.
- State the VDOT that a target needs. Compare it with the athlete's estimates, then give a realistic target and a stretch target.
- If the target needs much more weekly volume than the athlete can do, say so and ask which target the plan should prepare.
- Do not accept a pace the data cannot support. Show the numbers.

## 3. Time trial

A 10 km time trial predicts a half marathon better than a 5 km one.

1. Schedule it in a recovery-style week, on a flat and repeatable route.
2. Allow it only if the athlete has no pain for two weeks and no illness. Otherwise move it one week.
3. Warm up 15 min easy, with 4 strides. Run at an even pace. Start 5–10 s/km slower than goal pace for the first 2 km.
4. Record time, average and maximum heart rate, weather, and the knee or injury score the next morning.
5. It is a maximal effort. Advise a medical check for any heart or health condition. Stop for chest pain, dizziness, or severe breathlessness.

| 10 km | Pace | Predicted half marathon |
|---|---|---|
| 50:00 | 5:00/km | 1:50:52 |
| 52:00 | 5:12/km | 1:55:18 |
| 54:00 | 5:24/km | 1:59:43 |
| 56:00 | 5:36/km | 2:04:08 |
| 58:00 | 5:48/km | 2:08:33 |
| 60:00 | 6:00/km | 2:12:56 |

## 4. Build the base

- Raise weekly running time by at most about 10% per week. Use three build weeks, then one recovery week (*Training for the Uphill Athlete*).
- After a layoff or an injury, start with run-walk: 2 min jog and 2 min walk, then 3:1, then 4:1, then continuous.
  Keep the pain score at 2/10 or less during the run and the next morning. At 3/10, walk for one week.
- Easy running stays in Zone 2 by heart rate. Add Zone 3 only after the AeT and lactate-threshold spread is 10% or less (*Training for the Uphill Athlete*).
- Add pick-ups after a few weeks: 6 pick-ups of about 10 s, relaxed, with 2 min easy between, once a week (*Training for the Uphill Athlete*).
- A long run on flat ground and a short run after upper-body strength keep leg load low on the days before hard sessions.
- Plan the long run by time, not distance.

## 5. Plan around other training

Running adds impact load. When the athlete also climbs and lifts:

- Three running days, two strength sessions, and two climbing sessions are seven sessions. Check that they fit the available days.
- Put heavy leg strength two days before the long run, and keep the run after it easy.
- Keep the long run on its own day when the available days allow it.
