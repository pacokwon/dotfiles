{ pkgs, ... }:
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
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
      scheme-basic # minimal LaTeX scheme
      xetex # Recommended engine for kotex
      xetexko
      ;
  };
in
{
  environment.systemPackages = [
    tex
    pkgs.texlab
  ];
}
