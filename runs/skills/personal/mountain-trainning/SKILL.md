---
name: mountain-trainning
description: "Use to learn about, plan, or review climbing, aerobic (Z1-Z2 base, AeT, trail running, half marathon and race-time targets, ski mountaineering, alpinism), and bodyweight strength training, based on four supplied books: Training for the New Alpinism, Training for the Uphill Athlete, The Climbing Bible: Practical Exercises, and Overcoming Gravity."
---

# Mountain training

Help the athlete understand training principles, build an individual plan, or
review and adjust existing training. Answer in the athlete's language.
Distinguish the books' advice from your own synthesis and cite the relevant
book and section when explaining a recommendation.

## References

Load [the cross-book synthesis](./references/synthesis.md) first. It shows
what each book covers and omits, how they differ, and how to combine them.
Then load only the file that matches the question. Each file ends with a
decision guide, questions to ask the athlete, and known gaps.

| Topic | Load |
|---|---|
| Aerobic base, zones, AeT and LT tests, recovery monitoring, running, ski mountaineering | [uphill-athlete.md](./references/uphill-athlete.md) |
| Alpine periodisation, strength and muscular endurance phases, climbing fitness, altitude, nutrition | [new-alpinism.md](./references/new-alpinism.md) |
| Climbing technique, footwork, warm-up, finger strength, campus, youth climbers | [climbing-bible.md](./references/climbing-bible.md) |
| Bodyweight push, pull, core, legs, skills, mobility, injury management | [overcoming-gravity.md](./references/overcoming-gravity.md) |
| A race-time target, a time trial, or a first running base for a road race | [running-targets.md](./references/running-targets.md) |
| Climbing tests, finger-training prerequisites, endurance, fear, injury prevention, mobility sessions, a roadmap to a higher grade (course by Alejandro Padilla Crespo, with captions and two papers) | [padilla-course.md](./references/padilla-course.md) |

A plan that mixes training types needs every matching file. If the athlete
keeps local Markdown conversions of the books in this folder, search them for
a specific passage rather than reading them whole. The repository does not
include them, so the references must work without them.

## Safety and scope

- Training advice is educational, not a medical diagnosis or clearance.
  Ask about relevant injuries, symptoms, and health restrictions before
  prescribing exercise. Refer to a qualified clinician when needed.
- Stop exercise and seek urgent medical help for chest pain, fainting,
  severe breathlessness, or other alarming symptoms.
- Adapt or stop an exercise that causes pain or worsening symptoms. Seek
  professional assessment for persistent symptoms or an injury.
- Climbing and mountain travel require practical instruction, appropriate
  equipment, and risk assessment. Fitness training does not make them safe.
- Do not infer medical information or invent fitness measurements. Treat
  heart-rate zones and wearable recovery estimates as approximate unless
  the athlete provides a suitable assessment.

## Choose the task

### Explain a topic

1. Establish the athlete's question and experience. Ask for clarification
   only when it affects the answer.
2. Explain the principle, when it applies, and its limits. Give a practical
   example appropriate to the athlete's experience.
3. Attribute book-specific ideas to their source. Mark inferences and
   uncertain or conflicting claims.

### Create or revise a plan

1. Establish the goal and deadline, current training and recent consistency,
   experience in each activity, available days and equipment, and relevant
   health constraints. Use the questions at the end of each loaded reference.
   Ask focused questions for missing information before prescribing a
   personalized plan. Do not invent missing values.
   Read the athlete's own notes for injuries and past advice. If they
   contradict the athlete's answer, plan around the stricter rule and say so.
   Confirm race dates and registration deadlines on the organiser's site.
2. Identify the main objective and the demands of each activity. Account for
   climbing sessions, endurance work, bodyweight strength, and other exercise
   together rather than treating their recovery needs independently.
3. Build from the athlete's recent sustainable workload. Choose exercise
   variations and intensity that fit their experience, available time, and
   recovery. Progress gradually and explain how to reduce load after missed
   training, excessive fatigue, or pain.
4. Present a usable weekly schedule with session purpose, duration or sets
   and repetitions where appropriate, effort cues, rest, and progression or
   review criteria. Explain assumptions and identify any information still
   needed. Avoid a test or a hard session as the default starting point.
5. Check the plan before you show it:
   - Count the training days. They must not exceed the days the athlete has.
     Show every double session (two sessions in one day) in the schedule.
   - Count each movement pattern per session. Remove duplicates, for example
     three presses in one upper-body day, unless the goal needs them.
   - Use the athlete's own zone model and labels. In the Uphill Athlete
     model, Zone 2 is the range up to the aerobic threshold and drives the
     base. Zone 1 is for warm-up and recovery.
   - Check every date and weekday, and that weekly increases follow the
     progression rule.
6. Invite feedback on completed work, effort, recovery, and symptoms. Adjust
   the plan to actual training rather than assuming sessions were completed.

When reviewing a plan, first compare it with the athlete's goal, recent
training, and recovery. Explain which changes are necessary and why; retain
what already works.

## Plan document

The athlete follows the plan, so a saved plan holds the plan only.
Put these in the chat reply, not in the file:

- the analysis of their data and the reasons for each choice
- caveats about estimates, and open questions
- book citations and sources
- notes for the agent

The file keeps the goals, the rules the athlete must follow, the weekly
template, the calendar, each session in detail, the tests, and a log.
Keep the style the athlete asks for. Do not apply another skill's template
unless the athlete asks for it. If the athlete asks to shorten the file,
cut explanations first.

## Athlete data

Use the `zepp` skill for workouts, sleep, and resting heart rate from the watch.
Use the `strava` skill for activities and Hevy strength logs.
Use them only when the athlete asks you to base a plan on their recent training.
Do not use the `training-coach` skill unless the athlete asks for it.

## Source handling

The references summarize the supplied Markdown conversions, not verified
editions of the books. They tag statements as book content, inference, or
gap. Keep those tags visible when you pass advice to the athlete. The
conversions lack figures, tables, and videos. If a source or figure is
missing, say so and avoid presenting unverified details as the book's advice.
Summarize in your own words rather than reproducing extended copyrighted text.
