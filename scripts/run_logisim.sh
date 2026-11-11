#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
: "${LOGISIM_CP:?Set LOGISIM_CP to the Logisim 2.7.1 jar and dependency jars, separated by colons}"
java -Djava.awt.headless=true -cp "$LOGISIM_CP" "$ROOT/scripts/LogisimVerify.java" "$ROOT" > "$ROOT/results/logisim_summary.txt" 2> "$ROOT/results/logisim_stderr.txt"
cat "$ROOT/results/logisim_summary.txt"
