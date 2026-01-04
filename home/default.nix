{ config, pkgs, inputs, ... }: 
{

  home.username = "elias";
  home.homeDirectory = "/home/elias";

  home.shellAliases = {
    fz = "fzf --tmux"; 
  }; 

  imports = [
     ./pandoc
     ./nixvim
     ./style
     ./waybar.nix
     ./alacritty.nix
     ./rofi
     ./sway
     ./niri
     ];

  home.packages = with pkgs; [
    zoom-us
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
    signal-desktop
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
      extraPackages = tpkgs: {inherit (tpkgs) collection-mathscience collection-fontsrecommended collection-latexrecommended collection-fontutils collection-pictures collection-xetex collection-langenglish collection-latex collection-latexextra collection-langgerman collection-fontsextra collection-basic standalone gincltex svn-prov import; };
  };

  programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
      ];
  };

  programs.git = {
    enable = true;
    settings = {
        user.name = "Elias Peschke";
        user.email = "eliaspeschke@googlemail.com";
        init.defaultBranch = "main";
    };
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

