{ config, pkgs, inputs, ... }: 
{

  home.username = "peschkee";
  home.homeDirectory = "/home/peschkee";
  targets.genericLinux.enable = true; 

  imports = [
     ./common
     ];

  home.packages = with pkgs; [
    xca
    pidgin
  ];
  programs.git = {
    enable = true;
    settings = {
        user.name = "Elias Peschke";
        user.email = "elias.peschke@uni-greifswald.de";
        init.defaultBranch = "main";
    };
  };

  dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["compose:sclk"];
      };
    };

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

  programs.home-manager.enable = true; 
}

