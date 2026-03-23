{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions =
        with pkgs.vscode-extensions;
        [
          christian-kohler.path-intellisense
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          ms-python.python
          ms-python.debugpy
          platformio.platformio-vscode-ide
        ]
        ++ pkgs.nix4vscode.forVscode [
          "ms-vscode.cpptools.1.23.6"
        ];
    })
    tealdeer
    nixd
    alejandra
    nh
    statix
    deadnix
    nix-tree
    comma
    git
    github-desktop
    opencode
    platformio
    btdu  # btrfs disk usage analyzer. pita to use
    dust  # rust-based disk usage analyzer, but faster and harder to use
    ncdu  # ncurses disk usage analyzer, good ol reliable
    libgcc
    vim
    cdrkit
    prettier
    yq-go
  ];
}