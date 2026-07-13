{ config, pkgs, inputs, ... }: 
{

  home.username = "elias";
  home.homeDirectory = "/home/elias";

  imports = [
     ./common
     ];

  home.packages = with pkgs; [
    ardour
    telegram-desktop
    signal-desktop
    exercism
    blender
    valgrind
    tridactyl-native
    kdePackages.kcachegrind
    kicad
  ];

  services.dunst.enable = true;

  programs.git = {
    enable = true;
    settings = {
        user.name = "Elias Peschke";
        user.email = "eliaspeschke@googlemail.com";
        init.defaultBranch = "main";
    };
  };

  programs.firefox.nativeMessagingHosts = [pkgs.tridactyl-native];

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

  home.stateVersion = "24.11";

  programs.home-manager.enable = true; 
}

