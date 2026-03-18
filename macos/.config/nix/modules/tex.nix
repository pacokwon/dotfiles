{ pkgs, ... }:
let
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      acmart
      latexmk
      kotex-utf
      xetex       # Recommended engine for kotex
      collection-langkorean
      scheme-basic          # minimal LaTeX scheme
      collection-latex
      collection-latexrecommended
      collection-latexextra
      collection-pictures
      collection-mathscience
      collection-fontsrecommended;
  };
in
{
  environment.systemPackages = [
    tex
  ];
}
