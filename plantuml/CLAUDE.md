# CLAUDE.md — Event-Storming Board Operator

Source of truth: `event-storming.puml`. Never hand-edit PNG/SVG.

## How to change the board

1. Read `event-storming.puml` fully before editing.
2. Make the smallest diff that satisfies the request. Preserve all
   existing stable IDs (`E01_…`, `C02_…`, `A01_…`, `P01_…`, `R01_…`,
   `X01_…`, `H01_…`, `U01_…`). New stickies get the next free number
   in their prefix.
3. Use only these stereotypes (colors are bound to them):
   `<<event>>`, `<<command>>`, `<<aggregate>>`, `<<policy>>`,
   `<<readmodel>>`, `<<external>>`, `<<hotspot>>`, `<<actor>>`.
   Label text is `ID` newline `Name`, e.g. `"E06\nOrderCancelled"`.
   Do not repeat `<<…>>` inside the label string.
4. Packages are timeline phases (`"1. Browse & Cart"`, …). Keep
   left-to-right flow inside a phase. Keep the `-[hidden]down->`
   layout hints at the bottom — they force chronological order.
   Do not remove `!pragma layout smetana` or `left to right direction`.
5. Arrow vocabulary only:
   Command→Aggregate `: on`, Aggregate→Event `: emits`,
   Event→Policy `: triggers`, Policy→Command `: invokes`,
   Event→ReadModel `: projects` (dotted `..>`), External calls as
   `--> X : calls/requests`, `X --> Event : ok/ko`.
6. Bump the `title` version (`v0.3` → `v0.4`) with a 3-word note.
7. Verify: run `./render.sh` (runs both svg+png passes). It must exit 0
   and update `event-storming.png` + `.svg`. If render fails, revert
   the edit and report.
8. Summarise: what stickies were added/changed (IDs), what hotspot is
   still open, one suggested next question. Keep it under 10 lines.

## Do not

- Switch diagram type (no sequence/activity/salt). Rectangles only.
- Require Graphviz/dot. Smetana only.
- Rename or reuse IDs. Never delete a hotspot — convert to policy/event
  and note resolution instead.
- Do wide re-layouts unprompted. One concept per edit.
