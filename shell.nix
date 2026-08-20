{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    # Core: lean-zlib comparator baseline needs zlib + pkg-config.
    pkgs.pkg-config
    pkgs.zlib
    # miniz_oxide comparator — cargo+rustc build rust/miniz_oxide_shim/.
    # Without them, `lake build` still succeeds but the miniz stub raises
    # IO.userError at runtime.
    pkgs.cargo
    pkgs.rustc
    # libdeflate/zopfli reference comparators (C libs, linked directly via
    # c/*_ffi.c) and the matplotlib plotter that renders results/*.json
    # into the log-scale SVG graphs under graphs/.
    pkgs.libdeflate
    pkgs.zopfli
    (pkgs.python3.withPackages (ps: [ ps.matplotlib ]))
  ];
}
