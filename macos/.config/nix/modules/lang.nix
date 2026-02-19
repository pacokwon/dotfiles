{ pkgs, ... }:
let
  tex = (pkgs.texliveSmall.withPackages (
    ps: with ps; [
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of
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
