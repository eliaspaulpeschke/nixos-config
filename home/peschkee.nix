{ config, pkgs, inputs, ... }: 
{

  home.username = "peschkee";
  home.homeDirectory = "/home/peschkee";

  home.shellAliases = {
    fz = "fzf --tmux"; 
  }; 

  imports = [
     ./pandoc
     ./nixvim
     ./style
     ./alacritty.nix
#     ./i3
     ];

  home.packages = with pkgs; [
    zoom-us
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

    tmux
    gimp3-with-plugins
    inkscape-with-extensions

    google-chrome
    zathura
    latexrun
    texpresso

    valgrind

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
        user.email = "elias.peschke@uni-greifswald.de";
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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = "set -o vi";
  };

  programs.firefox = {
    enable = true;
  };	

  services.xserver = {
      enable = true;
  };

  xsession.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true; 
}

