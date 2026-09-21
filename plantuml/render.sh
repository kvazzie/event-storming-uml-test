#!/usr/bin/env bash
# Render PlantUML event-storming artifact to PNG + SVG (no Graphviz needed, uses Smetana).
set -euo pipefail
JAR="${PLANTUML_JAR:-/tmp/opencode/plantuml.jar}"
if [ ! -f "$JAR" ]; then
  echo "PlantUML jar not found at $JAR"
  echo "Download: curl -L -o /tmp/opencode/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2025.5/plantuml-1.2025.5.jar"
  exit 1
fi
cd "$(dirname "$0")"
java -jar "$JAR" -tsvg event-storming.puml
java -jar "$JAR" -tpng event-storming.puml
ls -lh event-storming.png event-storming.svg
