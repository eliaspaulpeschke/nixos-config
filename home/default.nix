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
    obsidian

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

    gimp3-with-plugins
    inkscape-with-extensions

    swaybg
    xwayland-satellite
    telegram-desktop
    #emanote
    swaylock-effects

    google-chrome
    exercism
    zathura
    latexrun
    texpresso
  ];

  programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {inherit (tpkgs) collection-mathscience collection-fontsrecommended collection-latexrecommended collection-basic collection-luatex standalone gincltex svn-prov import; };
  };

  programs.git = {
    enable = true;
    userName = "Elias Peschke";
    userEmail = "eliaspeschke@googlemail.com";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    #old defaults set explicitly
    matchBlocks = { 
        "*" = { 
            forwardAgent = false; 
            addKeysToAgent = "no"; 
            compression = false; 
            serverAliveInterval = 0; 
            serverAliveCountMax = 3; 
            hashKnownHosts = false; 
            userKnownHostsFile = "~/.ssh/known_hosts"; 
            controlMaster = "no"; 
            controlPath = "~/.ssh/master-%r@%n:%p"; 
            controlPersist = "no"; 
        };
    }; 
    
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

