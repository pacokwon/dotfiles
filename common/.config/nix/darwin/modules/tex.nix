{ pkgs, ... }:
let
  tex = pkgs.texliveSmall.withPackages (
    ps: with ps; [
      acmart
      collection-fontsrecommended
      collection-langkorean
      collection-latex
      collection-latexextra
      collection-latexrecommended
      collection-mathscience
      collection-pictures
      dvisvgm
      kotex-utf
      latexmk
      pdfjam
      xetex # Recommended engine for kotex
      xetexko
    ]
  );
in
{
  environment.systemPackages = [
    tex
    pkgs.texlab
  ];
}
