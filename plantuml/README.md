# Event-Storming with PlantUML + Coding Agent — Prototype

> Sibling D2 version of the same board: `../d2/`. Stable IDs match, so
> prompts transfer 1:1. Comparison at `../README.md`.

Proves you can run event-storming sessions with an agent (Claude Code etc.)
using a text-based PlantUML artifact as the shared board.

`event-storming.puml` is the source of truth. PNG/SVG are generated.
We just demoed the loop: prompt "add cancel path" → edited `.puml`
(C05/E06) → `./render.sh` → reviewed PNG. No manual drawing.

## Files

- `event-storming.puml` — the board (example domain: Online Order Checkout, v0.3)
- `event-storming.png` / `.svg` — rendered output (git-ignored;
  build with `./render.sh`, see published copy in `../.generated/`
  or download from CI), do not hand-edit
- `render.sh` — renders both formats (uses Smetana, no Graphviz needed)
- `CLAUDE.md` — operating instructions for the agent

## Prerequisites

- Java (you have 26, works)
- PlantUML jar, e.g.:
  `curl -L -o /tmp/opencode/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2025.5/plantuml-1.2025.5.jar`
- No Graphviz needed: file starts with `!pragma layout smetana`.

## Render

./render.sh
# or manually:
# java -jar /tmp/opencode/plantuml.jar -tsvg event-storming.puml
# java -jar /tmp/opencode/plantuml.jar -tpng event-storming.puml

VS Code tip: install "PlantUML" extension (jebbs), set renderer to
PlantUML server or local jar, and you get live preview side-by-side
while the agent edits.

## Notation (classic Big-Picture colors)

- orange Event (past tense, E01): `<<event>>`
- blue Command (imperative, C01): `<<command>>`
- yellow Aggregate (A01): `<<aggregate>>`
- lilac Policy "whenever… then…" (P01): `<<policy>>`
- green Read model (R01): `<<readmodel>>`
- grey External system (X01): `<<external>>`
- pink Hotspot / question / risk (H01): `<<hotspot>>`
- white Actor (U01): `<<actor>>`

IDs are stable (`E02_OrderPlaced`) so you and the agent can refer to
stickies unambiguously. Time flows left → right. Arrows = causality:
`Command --> Aggregate : on`, `Aggregate --> Event : emits`,
`Event --> Policy : triggers`, `Policy --> Command : invokes`,
`Event ..> ReadModel : projects`.

## Agent session workflow

1. Start with narrative: "Shopper adds to cart, places order, pays via
   Stripe, warehouse ships. We also allow cancel before shipment."
2. Ask agent: "Reconcile narrative vs board, list missing events/commands
   as bullet list, don't edit yet."
3. Pick one change: "Add E06 OrderCancelled path you proposed."
4. Agent edits only `event-storming.puml` (small diff, preserves IDs),
   bumps title version, runs `./render.sh`.
5. You review `git diff event-storming.puml` + PNG. Say "keep / revert /
   adjust: move X into phase 3".
6. Repeat per hotspot: H01, H02, H03 are seeded open questions.
   Resolve one per iteration.
7. When a cluster stabilises, ask: "Propose bounded contexts / aggregates
   slice for phases 2-3, as note + new package, don't re-layout."

Keep iterations small — one event/policy/hotspot at a time. Smetana
auto-layout is brittle; large rewrites cause arrow spaghetti.

## Example prompts to try

- "Add command C06 RefundPayment + event E07 PaymentRefunded after
  E06, wired through X01 Stripe, and re-render."
- "H02 double-click PlaceOrder worries me. Add idempotency policy
  P04 + note which aggregate enforces the key."
- "Where is the read model for shopper tracking? Add R04 if missing."
- "List all hotspots H01-H03 and propose a resolution for each,
  one sentence each, no edits yet."
- "Slice aggregates A01/A02/A03 into candidate bounded contexts and
  explain in 5 bullets."
- "Export a 10-line chronological event list E01-E06 for our ADR."

## PlantUML fit — honest verdict

Good for agent sessions: text + git diff + CI rendering, stable IDs,
cheap branching, works offline, no Miro lock-in. Smetana removes the
Graphviz dependency.

Limits: not a free-form sticky wall — layout is auto, not spatial;
wide timelines get tiny text; no real-time multi-cursor collaboration;
colour/sticky aesthetics are approximate. If you need facilitated
big-room workshops with 10 people moving stickies, use Miro/FigJam and
let the agent transcribe into `.puml` afterwards. For 1-3 people +
agent iterating on process/design, PlantUML is enough.

Alternatives if this chafes: Mermaid (weaker styling), Structurizr /
ContextMapper (better for bounded-context design phase), plain
`events.md` list feeding the `.puml` (often the best starting point).

## Next steps

- `git init; git add .; git commit` so each session is a reviewable diff.
- Replace the checkout example with your domain, keep the ID scheme.
- Try: "Interview me phase by phase, one question at a time, updating
  the board after each answer."
