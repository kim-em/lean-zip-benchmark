import BenchTests.MinizOxide
import BenchTests.Libdeflate
import BenchTests.Zopfli
import BenchTests.FuzzCompress
import BenchTests.ReportTiming

/-! Dev-only conformance + fuzz test driver for the comparators.

These modules moved out of the root `test` driver together with the
comparator `extern_lib`s they need. Each comparator test self-skips (via
its `"<name>: not built with"` marker) when the comparator toolchain is
absent, so this driver stays green on minimal toolchains; with cargo /
libdeflate / zopfli present it exercises the real comparators. The
compressor fuzz module runs its default (short) budget. (The inflate and
Handle.read fuzz harnesses live in lean-zip's conformance package and in
lean-archive, respectively.) -/

def main : IO Unit := do
  ZipTest.MinizOxide.tests
  ZipTest.Libdeflate.tests
  ZipTest.Zopfli.tests
  ZipTest.FuzzCompress.tests
  ZipTest.ReportTiming.tests
  IO.println "\nAll bench tests passed!"
