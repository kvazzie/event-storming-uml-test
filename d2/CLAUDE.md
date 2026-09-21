# CLAUDE.md — Event-Storming Board Operator (D2)

Source of truth: `event-storming.d2`. Never hand-edit SVG/PNG.

## How to change the board

1. Read `event-storming.d2` fully before editing.
2. Smallest diff that satisfies the request. Node keys are
   `<cell>.<STABLE_ID>` (e.g. `p2_trigger.C02_PlaceOrder`, cells are
   `<phase p1-p4>_<band trigger|react|events|enforce>`); the part
   after the dot is the stable ID — never rename it, never reuse a
   number. New stickies take the next free number of their prefix
   (E/C/A/P/R/X/H/U) and go in their band's cell for that phase.
3. Stickies use `class:` only (`event`, `command`, `aggregate`,
   `policy`, `readmodel`, `external`, `hotspot`, `actor`). Colors live
   in `classes:` — don't inline `style.fill` on stickies. Label is
   `"ID\nName"`, e.g. `label: "E06\nOrderCancelled"`.
4. `board` is ONE grid (5 cols x 5 rows, row-major: `grid-rows`
   declared first, children listed row by row). Never reorder children,
   never change dimensions without refilling all 25 cells. Body cells
   carry `label: ""`; empty bands hold a `ghost` placeholder.
   `direction: right` is global — nested per-container `direction` is
   ignored by TALA, so don't add any.
5. Edge vocabulary only: `-> X: on|emits|triggers|invokes|calls|requests|ok|ko`.
   Projections and hotspot links are dashed:
   `A -> B: { label: projects; style: { stroke-dash: 4 } }`.
6. Legend is a vertical stack of class-colored chips (`direction: down`
   on `legend` is honored — keep it). Don't rebuild it as a grid.
   Don't add a `title:` key (D2 renders it as a shape, not a header).
7. Verify: `./render.sh` must exit 0 and refresh both outputs.
   `d2 validate event-storming.d2` is a faster syntax-only check.
8. Summarise: changed/added IDs, open hotspots left, one suggested next
   question. Under 10 lines.

## Do not

- Re-layout the whole board, switch engines, or "tidy" coordinates.
- Inline styles to "fix" one node — change the class instead.
- Delete hotspots — convert to policy/event and note the resolution.
- One concept per edit.
