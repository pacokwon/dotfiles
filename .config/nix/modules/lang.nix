{ pkgs, ... }:
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
  ];
}
