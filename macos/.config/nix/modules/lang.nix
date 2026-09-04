{ pkgs, ... }:
{
  environment.variables = {
    JAVA_HOME = "${pkgs.jdk21}";
  };

  environment.systemPackages = with pkgs; [
    cargo
    clang-tools
    deno
    dune-release
    elan
    go
    jdk21
    lua-language-server
    markdownlint-cli2
    nixd
    nixfmt
    nodejs_22
    opam
    pyright
    python314
    ruff
    rustc
    tree-sitter
    typst
    vtsls
    yarn-berry_3
  ];
}
