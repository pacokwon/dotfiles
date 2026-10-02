# Darwin-only language toolchains. Cross-platform ones live in ../../common/packages.nix.
{ pkgs, ... }:
{
  environment.variables = {
    JAVA_HOME = "${pkgs.jdk21}";
  };

  environment.systemPackages = with pkgs; [
    cargo
    clang-tools
    dune-release
    elan
    go
    jdk21
    nodejs_22
    rustc
    typst
    vtsls
    yarn-berry_3
  ];
}
