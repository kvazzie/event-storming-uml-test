#!/usr/bin/env bash
# Render D2 event-storming artifact to SVG + PNG.
set -euo pipefail
D2_BIN="${D2_BIN:-d2}"
if ! command -v "$D2_BIN" >/dev/null 2>&1; then
  echo "d2 not found (looked for '$D2_BIN')."
  echo "Install: https://d2lang.com/tour/install/  (e.g. curl -fsSL https://d2lang.com/install.sh | sh -s --)"
  exit 1
fi
# TALA routes edges between grid cells; dagre/ELK draw straight
# center-center segments inside grids. Override with D2_LAYOUT=elk|dagre.
export D2_LAYOUT="${D2_LAYOUT:-tala}"
cd "$(dirname "$0")"
"$D2_BIN" event-storming.d2 event-storming.svg
"$D2_BIN" event-storming.d2 event-storming.png
chmod 644 event-storming.svg event-storming.png
ls -lh event-storming.svg event-storming.png
