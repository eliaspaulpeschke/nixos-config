{config,lib,...}:
{
    wayland.windowManager.sway = {
        enable = true;
        config = {
            gaps = {
                inner = 12;
                outer = 48;
            };
            floating.border = 1;
            window.border = 1;

            input = {
                "*" = {
                    xkb_layout = "us,us";
                    xkb_variant = ",colemak_dh";
                    xkb_options = "grp:alt_space_toggle";
                    xkb_model = "pc104";
                };
            };
           bars =  [];

           modifier = "Mod4";
           keybindings = lib.mkOptionDefault {
              "Mod4+Return" = "exec alacritty";
              "Mod4+Shift+q" = "kill";
              "Mod4+d" = "exec rofi -show run";
              "Mod4+s" = "layout stacking";
              "Mod4+w" = "layout tabbed";
           };
            window.titlebar = false;
        };
    };
}
