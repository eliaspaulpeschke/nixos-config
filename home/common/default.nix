{ config, pkgs, inputs, ... }: 
{
  imports = [
     ./pandoc
     ./nixvim
     ./style
     ./alacritty.nix
     ./i3
     ];

  home.packages = with pkgs; [
    xclip
    cryptsetup
    element-desktop
    zoom-us
    zip
    xz
    unzip
    p7zip
    kdePackages.okular
    chromium
    ripgrep
    file
    which
    gnutar
    gnupg
    dnsutils
    htop
    lsof
    pciutils
    usbutils
    lynx
    gimp3-with-plugins
    inkscape-with-extensions
    google-chrome
    zathura
    latexrun
    texpresso
    dmenu
    keepassxc

    pkgs.nerd-fonts.geist-mono
    pkgs.nerd-fonts.fira-mono
    (pkgs.callPackage ./fonts/default.nix { lib = lib; stdenv = stdenv; })

  ];

  fonts.fontconfig.enable = true;

  programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = "set -o vi";
    shellAliases = {
        track = "python3 $HOME/.local/bin/track.py";
        fz = "fzf --tmux"; 
    };
  };

  programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
      ];
  };

  home.keyboard = {
    layout = "us";
    options = [ 
      "compose:sclk"
    ];
  };

  programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {inherit (tpkgs) collection-mathscience collection-fontsrecommended collection-latexrecommended collection-fontutils collection-pictures collection-xetex collection-langenglish collection-latex collection-latexextra collection-langgerman collection-fontsextra collection-basic standalone gincltex svn-prov import; };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    KUBE_EDITOR = "nvim";
  };

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
  };	

}
