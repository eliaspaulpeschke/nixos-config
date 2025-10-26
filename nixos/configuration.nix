# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./niri
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth = {
      enable = true;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
  hardware.keyboard.qmk.enable = true; 

  services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
  };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "twinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.elias = {
    isNormalUser = true;
    description = "Elias Peschke";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "dialout" "plugdev"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wev
    socat
    wget
    git
    xdg-user-dirs
    man-pages
    man-pages-posix
    (haskell-language-server.override { 
              supportedGhcVersions = [ "96" "98"];
              
   })
    brightnessctl
  ];

 documentation = {
    enable = true;
    dev.enable = true;
    info.enable = true;
    doc.enable = true;
    nixos = { 
        enable = true;
        includeAllModules = true;
        options.splitBuild = true;
        options.warningsAreErrors = false;
    };
    man = {
        enable = true;
        man-db.enable = true;
        generateCaches = true;
    };
 };

 environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  programs.adb.enable = true;


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.fuse.userAllowOther = true;

  services.udev = { 
      packages = [
        pkgs.android-udev-rules
      ];
      extraRules = (builtins.readFile ./udev-rules-mtkclient/50-android.rules) + "\n\n" + (builtins.readFile ./udev-rules-mtkclient/51-edl.rules);
  };

  services.actkbd = {
      enable = true;
      bindings = [
          { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl s 5%-"; }
          { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl s +5%"; }
      ];
  };


  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    nerd-fonts.fira-mono
  ];
  
  virtualisation.waydroid.enable = true;

  security.rtkit.enable = true;




  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
