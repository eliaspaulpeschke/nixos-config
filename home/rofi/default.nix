{pkgs, ...}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = ./squared-everforest.rasi;
  };
}
