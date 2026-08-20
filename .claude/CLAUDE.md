# lean-zip-benchmark

Benchmark dashboard and comparator harness for kim-em/lean-zip (verified
DEFLATE in Lean 4). Extracted from lean-zip's bench/ sub-package; the
committed dashboard is frozen at the August 2026 state.

## Build and Test

    lake build      # comparators auto-detect; absent toolchains become stubs
    lake test       # comparator conformance + fuzz-compress
    python3 -m unittest discover -s . -p 'test_*.py'

On NixOS use `nix-shell` (provides zlib, cargo/rustc, libdeflate, zopfli,
python+matplotlib). Full dashboard refresh: `run.sh` (see README.md for
the measurement protocol — median-of-5, pinned core, provenance rules).

## Standards

- Measurement discipline is documented in README.md and enforced by the
  python unittests (timing protocol, merge provenance, frontier maths).
  Don't weaken those checks to make a refresh easier.
- Routine before/after claims need two median-of-5 snapshots under the
  same protocol; single-shot timings are for tuning only.
- Comparator stubs must keep `lake build` green without their toolchain.
