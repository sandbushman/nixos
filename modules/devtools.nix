{ pkgs, lib, ... }:
let
  nix4vscode-src = builtins.fetchGit {
    url = "https://github.com/nix-community/nix4vscode.git";
    ref = "refs/heads/master";
  };
  forVscodeVersionRaw = import "${nix4vscode-src}/nix/forVscodeVersionRaw.nix";
  vscodeVersion = pkgs.vscode.version or pkgs.vscodium.version;
  vscodiumVersion = pkgs.vscodium.version;
  mkVscodeFun = { version, pickPreRelease, isOpenVsx, decorators }:
    extensions: forVscodeVersionRaw {
      inherit pkgs extensions pickPreRelease isOpenVsx decorators;
      dataPath = if isOpenVsx 
        then "${nix4vscode-src}/data/extensions_openvsx.json"
        else "${nix4vscode-src}/data/extensions.json";
    };
  nix4vscode = rec {
    forVscode = mkVscodeFun { version = vscodeVersion; pickPreRelease = false; isOpenVsx = false; decorators = null; };
    forVscodeVersion = version: mkVscodeFun { inherit version; pickPreRelease = false; isOpenVsx = false; decorators = null; };
    forVscodePrerelease = mkVscodeFun { version = vscodeVersion; pickPreRelease = true; isOpenVsx = false; decorators = null; };
    forVscodeVersionPrerelease = version: mkVscodeFun { inherit version; pickPreRelease = true; isOpenVsx = false; decorators = null; };
    forVscodeExt = decorators: mkVscodeFun { version = vscodeVersion; pickPreRelease = false; isOpenVsx = false; inherit decorators; };
    forVscodeExtVersion = decorators: version: mkVscodeFun { inherit version decorators; pickPreRelease = false; isOpenVsx = false; };
    forVscodeExtPrerelease = decorators: mkVscodeFun { version = vscodeVersion; pickPreRelease = true; isOpenVsx = false; inherit decorators; };
    forVscodeExtVersionPrerelease = decorators: version: mkVscodeFun { inherit version decorators; pickPreRelease = true; isOpenVsx = false; };
    forOpenVsx = mkVscodeFun { version = vscodiumVersion; pickPreRelease = false; isOpenVsx = true; decorators = null; };
    forOpenVsxVersion = version: mkVscodeFun { inherit version; pickPreRelease = false; isOpenVsx = true; decorators = null; };
    forOpenVsxPrerelease = mkVscodeFun { version = vscodiumVersion; pickPreRelease = true; isOpenVsx = true; decorators = null; };
    forOpenVsxVersionPrerelease = version: mkVscodeFun { inherit version; pickPreRelease = true; isOpenVsx = true; decorators = null; };
    forOpenVsxExt = decorators: mkVscodeFun { version = vscodiumVersion; pickPreRelease = false; isOpenVsx = true; inherit decorators; };
    forOpenVsxExtVersion = decorators: version: mkVscodeFun { inherit version decorators; pickPreRelease = false; isOpenVsx = true; };
    forOpenVsxExtPrerelease = decorators: mkVscodeFun { version = vscodiumVersion; pickPreRelease = true; isOpenVsx = true; inherit decorators; };
    forOpenVsxExtVersionPrerelease = decorators: version: mkVscodeFun { inherit version decorators; pickPreRelease = true; isOpenVsx = true; };
  };
in
{
  environment.systemPackages = with pkgs; [
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        christian-kohler.path-intellisense
        jnoortheen.nix-ide
        arrterian.nix-env-selector
        ms-python.python
        ms-python.debugpy
        platformio.platformio-vscode-ide
      ] ++ nix4vscode.forVscode [
        "ms-vscode.cpptools.1.23.6"
      /*
      ] ++ nix4vscode.forOpenVsx [
        "rust-lang.rust-analyzer"
      */
      ];
    })
    tealdeer
    nixd
    nixfmt
    git
    github-desktop
    opencode # vibecoding in vscode
    platformio # arduino
    ncdu
    libgcc
  ];

  # installs an FHS-compatible linker that
  # allows dynamically-linked Linux binaries to run.
  programs.nix-ld.enable = true;
}