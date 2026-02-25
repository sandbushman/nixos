{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zoom-us
    libreoffice
    # teams
    ];

  programs.zoom-us.enable = true;
}