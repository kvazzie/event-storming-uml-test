# Event-Storming with D2 + Coding Agent — Prototype

D2 sibling of `../plantuml/` — same board, same stickies, same stable IDs
(Online Order Checkout). Edit the `.d2`, re-render, review the diff.

## Files

- `event-storming.d2` — the board, source of truth
- `event-storming.svg` / `.png` — rendered output, do not hand-edit
- `render.sh` — renders both (layout ELK, override with `D2_LAYOUT=dagre`)
- `CLAUDE.md` — operating instructions for the agent

## Prerequisites

- `d2` v0.9.0+ (dagre/elk/tala all bundled, no extra install):
  `curl -fsSL https://d2lang.com/install.sh | sh -s --`
  Full guide: https://d2lang.com/tour/install/
- Nothing else. SVG and PNG export are built in
  (`d2 in.d2 out.png` just works).

## Render

./render.sh
# or manually:
# d2 event-storming.d2 event-storming.svg
# d2 event-storming.d2 event-storming.png

Live iteration while facilitating:

d2 --watch event-storming.d2 event-storming.svg   # browser live-reload

VS Code tip: the "D2" extension (Terrastruct) previews `.d2` side-by-side
while the agent edits — same loop as the PlantUML extension.

## Layout — convention grid, not a timeline graph

`board` is one 5×5 D2 grid. Columns are time (one per phase),
rows are Event-Storming bands, top to bottom:

- Trigger (actor, command, read model) → React (policy) →
  Record (domain events, the spine) → Enforce (aggregate, system).
- Row 0 holds phase headers, column 0 the band labels.
- Hotspots stick to the cell of whatever they question.
- Empty bands (Browse/Checkout have no policies) hold invisible
  `ghost` placeholders — the grid needs all 25 cells to stay aligned.

`render.sh` sets `D2_LAYOUT=tala`: TALA routes edges between grid
cells; dagre/ELK draw straight center-center segments inside grids.
`direction: right` is global. Verified TALA quirks (v0.9.0, documented
in `event-storming.d2` header): nested per-container `direction: right`
is ignored, so the legend is a vertical chip stack, and body cells use
`label: ""` to hide their keys. `d2 fmt` / `d2 validate` still apply.

## Notation (same as PlantUML sibling)

- orange Event `E01` / blue Command `C01` / yellow Aggregate `A01`
- lilac Policy `P01` / green ReadModel `R01` / grey External `X01`
- pink Hotspot `H01` / person-shape Actor `U01`
- solid edge = causality (`on`, `emits`, `triggers`, `invokes`, `calls`);
  dashed edge = projection (`projects`) or open question link.
- Node keys are `<cell>.<STABLE_ID>` (e.g. `p2_trigger.C02_PlaceOrder`,
  cells are phase × band); the part after the dot is the stable
  cross-tool ID.

## D2 specifics worth knowing

- Sticky colors live in `classes:` at the top — one place to restyle.
- Legend is a `grid-columns: 2` container of swatch/text pairs.
- No board `title:` key — D2 renders it as a shape, so the title lives
  here, not in the diagram. Same info, less clutter.
- `d2 fmt` normalises formatting; `d2 validate` type-checks without rendering.
- `d2 --sketch` gives a hand-drawn sticky-note look — fun for workshops.

## Agent session workflow

Same loop as `../plantuml/README.md`: narrate → agent proposes (no edit)
→ one small edit → `./render.sh` → review `git diff` + PNG.
Hotspots H01/H02/H03 are seeded open questions — resolve one per iteration.
