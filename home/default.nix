{ config, pkgs, inputs, ... }: 
{

  home.username = "elias";
  home.homeDirectory = "/home/elias";

  home.shellAliases = {
    fz = "fzf --tmux"; 
  }; 

  imports = [
     ./nixvim
     ./style
     ./waybar.nix
     ./alacritty.nix
     ./rofi
     ./niri
     ];

  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

    chromium

    ripgrep
    fzf

    dnsutils

    file
    which
    gnutar
    gnupg
 
    htop
    lsof
    pciutils
    usbutils

    lynx
    tmux

    swaybg
    xwayland-satellite
    telegram-desktop
    emanote
  ];

  programs.git = {
    enable = true;
    userName = "Elias Peschke";
    userEmail = "eliaspeschke@googlemail.com";
  };

  programs.ssh = {
    enable = true;
  };

  programs.fuzzel.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = "set -o vi";
  };

  programs.firefox = {
    enable = true;
  };	

  home.stateVersion = "24.11";

  programs.home-manager.enable = true; 

}

