#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GHDL_BIN="${GHDL_BIN:-ghdl}"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT
cd "$BUILD_DIR"
"$GHDL_BIN" --version > "$ROOT/results/ghdl_version.txt"
for name in rs_latch d_latch d_ff jk_ff d_ff_async; do
  "$GHDL_BIN" -a --std=08 "$ROOT/vhdl/$name.vhd" "$ROOT/tb/tb_$name.vhd"
  "$GHDL_BIN" -e --std=08 "tb_$name"
  "$GHDL_BIN" -r --std=08 "tb_$name" --assert-level=error --vcd="$ROOT/results/$name.vcd" > "$ROOT/results/${name}_simulation.txt" 2>&1
  "$GHDL_BIN" --synth --std=08 --latches "$name" > "$ROOT/results/${name}_synth.vhd" 2> "$ROOT/results/${name}_synthesis.txt"
  mkdir "$BUILD_DIR/$name"
  (
    cd "$BUILD_DIR/$name"
    "$GHDL_BIN" -a --std=08 "$ROOT/results/${name}_synth.vhd" "$ROOT/tb/tb_$name.vhd"
    "$GHDL_BIN" -r --std=08 "tb_$name" --assert-level=error > "$ROOT/results/${name}_netlist_simulation.txt" 2>&1
  )
  echo "PASS $name: RTL simulation, synthesis, synthesized-netlist simulation"
done
