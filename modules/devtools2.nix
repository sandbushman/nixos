{ pkgs, lib, ... }:
let
  nix-vscode-extensions-src = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions.git";
      ref = "refs/heads/master";
    }
  );
  resetLicense =
    drv:
    drv.overrideAttrs (prev: {
      meta = prev.meta // {
        license = [ ];
      };
    });

  pkgs' = pkgs.extend nix-vscode-extensions-src.overlays.default;
  fixedExt = pkgs'.nix-vscode-extensions.usingFixesFrom pkgs';
in
{
  nixpkgs.overlays = [
    nix-vscode-extensions-src.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    tldr
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions =
        (with vscode-extensions; [
          christian-kohler.path-intellisense
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          ms-python.python
          ms-python.debugpy
          llvm-vs-code-extensions.vscode-clangd
					platformio.platformio-vscode-ide
        ])
        ++ (lib.lists.optionals (lib.lists.elem stdenv.hostPlatform.system lib.platforms.linux) (
          with fixedExt.vscode-marketplace;
          [
            #(resetLicense ms-vscode.cpptools)
          ]
        ));
    })
    nixd
    nixfmt
    git
    github-desktop
    opencode # vibecoding in vscode
    platformio-core # arduino
    ncdu
  ];
}
