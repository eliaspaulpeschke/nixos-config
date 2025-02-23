{ config, pkgs, inputs, ... }: 

{

  home.username = "elias";
  home.homeDirectory = "/home/elias";

  imports = [
      inputs.niri.homeModules.niri
     ./nixvim
     ./style
     ./waybar.nix
     ./niri/style.nix
     ];

  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

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
  ];

  programs.git = {
    enable = true;
    userName = "Elias Peschke";
    userEmail = "eliaspeschke@googlemail.com";
  };

  programs.alacritty = {
    enable = true;
  };

  programs.fuzzel.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.firefox = {
    enable = true;
  };	

  home.stateVersion = "24.11";

  programs.home-manager.enable = true; 

}

