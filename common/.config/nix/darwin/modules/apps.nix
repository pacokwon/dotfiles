{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wezterm
    obsidian
    slack
    zoom-us
    iina
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-python.python
      ];
    })
  ];
}
