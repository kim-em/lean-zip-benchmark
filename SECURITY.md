# Security

This repository is measurement tooling, not a shipping library, but the
comparator shims execute third-party C and Rust codecs. This documents
the one nontrivial trust boundary and its guardrails.

## miniz_oxide via Rust

- Components: [`c/miniz_oxide_ffi.c`](c/miniz_oxide_ffi.c),
  [`rust/miniz_oxide_shim/`](rust/miniz_oxide_shim/),
  [`Bench/MinizOxide.lean`](Bench/MinizOxide.lean)
- Status: `guarded-locally`
- Trust boundary: an opt-in pure-Rust DEFLATE implementation
  (`miniz_oxide` v0.8) exposed through a `staticlib` Cargo crate and a
  thin C-ABI shim. The public `MinizOxide.compress` / `MinizOxide.decompress`
  Lean APIs would process attacker-controlled bytes if a downstream caller
  wired them into a non-bench codepath; the only callers here are
  [`ZipBench.lean`](ZipBench.lean) (`compress-miniz` / `inflate-miniz`) and
  the smoke tests in [`BenchTests/MinizOxide.lean`](BenchTests/MinizOxide.lean).
  The module is **not** part of the verified DEFLATE pipeline.
- Current local guardrails:
  - opt-in by default: build skipped when `cargo` is absent or
    `MINIZ_OXIDE_DISABLE=1` is set; the C shim falls back to an
    `IO.userError` containing `"miniz_oxide: not built with Rust support"`,
    which the smoke tests treat as a clean skip
  - `MinizOxide.decompress` carries a `maxDecompressedSize` cap (default
    1 GiB; `0` opts into bomb-unsafe unlimited mode); overruns raise
    `IO.userError` containing `"exceeds limit"`
  - the Rust shim is built with `panic = "abort"` so panics inside
    `miniz_oxide` cannot unwind across the FFI boundary
  - the shim allocates output as `Box<[u8]>` and exposes
    `lean_miniz_oxide_free`; the Lean side copies into a fresh
    `lean_alloc_sarray` buffer and frees through the shim, so no
    Rust-allocator vs. libc-allocator mismatch is possible
- **`Cargo.lock` is tracked and treated as security-critical.**
  [`rust/miniz_oxide_shim/Cargo.lock`](rust/miniz_oxide_shim/Cargo.lock)
  pins the resolved versions and registry checksums.
  Snapshot as of 2026-04-29: `miniz_oxide` 0.8.9, `adler2` 2.0.1.
  Any change to these
  resolved versions requires re-evaluating the trust boundary above and
  updating this snapshot; drift is surfaced advisorily by
  [`scripts/check-cargo-lock.sh`](scripts/check-cargo-lock.sh).
  [`scripts/sanitize-rust-ffi.sh`](scripts/sanitize-rust-ffi.sh) is a
  skeleton ASan recipe for the shim (body still TODO).

## libdeflate / zopfli via C

Plain system C libraries linked directly when their headers are present
(`LIBDEFLATE_DISABLE=1` / `ZOPFLI_DISABLE=1` to opt out; stub fallbacks
otherwise). They run only on bench inputs; treat them as
`upstream-risk` system dependencies, like zlib in lean-zlib.
