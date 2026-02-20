{ config, pkgs, inputs, ... }: 
{

  home.username = "peschkee";
  home.homeDirectory = "/home/peschkee";
  targets.genericLinux.enable = true; 
  fonts.fontconfig.enable = true;

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
    keepassxc
    pkgs.nerd-fonts.geist-mono
    pkgs.nerd-fonts.fira-mono

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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = "set -o vi";
    shellAliases = {
        track = "python3 track.py";
    };
  };

  programs.firefox = {
    enable = true;
  };	

  services.xserver = {
      enable = true;
  };

  xsession.enable = true;

  home.stateVersion = "25.11";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".local/bin/track.py" = {
        source = ./track.py;
        executable = true;
        force = true;
    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/peschkee/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    KUBU_EDITOR = "nvim";
  };


  programs.home-manager.enable = true; 
}

