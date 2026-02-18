{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.zoom-us
    # teams
    ];

  programs.zoom-us.enable = true;
}