# Habit Tracker

A simple, private habit tracker built with **Flutter** and **SQLite (sqflite)** to help people track and stay accountable in addiction recovery.

No login. No cloud sync. No data export. Everything stays on the device.

## Why local-only?

This app deliberately has **no account system and no export feature**. The data it stores — daily check-ins, slips, and craving/urge logs — is sensitive, and the goal was to make sure it never leaves the device unless someone chooses to move the phone itself. SQLite via `sqflite` was chosen specifically for this reason: everything lives in a local database file, nothing is ever synced or uploaded.

## Features

- **Habit tracking with streaks** — log each day as a success or a slip; current and longest streaks are calculated from check-in history (a missed day breaks a streak, same as a logged slip)
- **Milestone celebrations** — a small celebration triggers when a streak hits 7, 30, 90, 180, or 365 days
- **Urge/craving logging** — log the intensity (1–5) and optional trigger notes for cravings, separate from daily check-ins, so patterns can be reviewed later
- **Stats & charts** — per-habit view of current/longest streak, total urges logged, and a weekly success-rate bar chart over the last 8 weeks
- **Daily scripture** — a curated, addiction-recovery-themed Bible verse shown on the home screen, changing daily (deterministic by day-of-year, works fully offline)
- **Delete habit** — remove a habit and all its associated check-ins and urge logs, behind a confirmation dialog (irreversible, so it's a deliberate two-step action)

## Tech stack

- **Flutter** — UI
- **sqflite** — local SQLite database
- **fl_chart** — weekly success-rate bar chart
- **path** — cross-platform database file path handling

## Data model

Three tables, all local to the device:

| Table | Purpose |
|---|---|
| `habits` | The habits being tracked (id, name, created date) |
| `check_ins` | One row per habit per day — status (`success`/`slip`) and an optional note |
| `urges` | Timestamped craving logs — intensity (1–5) and an optional trigger note |

Streaks are **never stored** — they're recalculated from check-in history every time they're displayed, so there's no risk of a stored number drifting out of sync with the actual data.

## Getting started

```bash
flutter pub get
flutter run
```

## Project structure

```
lib/
  main.dart
  models/          # Habit, CheckIn, Urge — data classes + SQLite mapping
  db/
    database_helper.dart   # SQLite connection, schema, CRUD
  logic/
    streak_calculator.dart # streak + milestone algorithms
    stats_calculator.dart  # weekly success-rate calculation
    scripture_provider.dart
  screens/
    home_screen.dart
    add_habit_screen.dart
    check_in_screen.dart
    log_urge_screen.dart
    stats_screen.dart
```

## Status

Core features complete and working end to end: add habit → daily check-in → streak/milestone tracking → urge logging → stats → delete habit.

## License

MIT