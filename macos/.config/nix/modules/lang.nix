{ pkgs, ... }:
let
  tex = (pkgs.texliveSmall.withPackages (
    ps: with ps; [
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of

      # Add these for ACM and Korean support
      acmart
      hyperxmp
      comment
      inconsolata
      environ     # Required by acmart
      totpages    # Required by acmart
      ifmtarg     # Required by acmart
      ncctools    # Often required for many-column layouts in ACM
      kotex-utf   # For \usepackage{kotex} support
      xetex       # Recommended engine for kotex
      collection-langkorean
      lipsum

      # Logic and String handling (Required by acmart)
      xstring
      etoolbox

      # Fonts and Symbols
      amsfonts
      ncctools
      cabin
      libertine
      sourcecodepro

      latexmk
  ]));
in
{
  environment.systemPackages = with pkgs; [
    deno
    go
    rustc
    cargo
    opam
    nodejs_22
    yarn-berry_3
    python314
    markdownlint-cli2
    clang-tools
    tree-sitter
    aider-chat
    rocq-core
    rocqPackages.stdlib
    nixd
    tex
  ];
}
