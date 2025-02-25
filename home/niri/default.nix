{...}:
{
  imports = [
    ./binds.nix
    ./style.nix
  ];

  programs.niri.settings = {

    input.keyboard.xkb = {
      layout = "us";
      model = "pc104";
    };

    prefer-no-csd = true;

    spawn-at-startup = [
      { command = ["sleep 30; systemctl --user restart swaybg"]; }
    ];

  };
}
