{config,lib,...}:
{
    xsession.windowManager.i3 = {
        enable = true;
        config = {
#           output = {
#               DP-1 = {
#                   scale = "1.5";
#               };
#           };
            gaps = {
                inner = 5;
                outer = 5;
            };
            floating.border = 1;
            window.border = 1;

#           input = {
#               "*" = {
#                   xkb_layout = "us,us";
#                   xkb_variant = ",colemak_dh";
#                   xkb_options = "grp:alt_space_toggle";
#                   xkb_model = "pc104";
#               };
#               "type:touchpad" = {
#                   natural_scroll = "enabled";
#               };
#           };

           bars =  [];

           modifier = "Mod4";
           keybindings = lib.mkOptionDefault {
              "Mod4+Return" = "exec alacritty";
              "Mod4+Shift+q" = "kill";
              "Mod4+d" = "exec rofi -show run";
              "Mod4+s" = "echo 'hello'";
              "Mod4+w" = "echo 'hello'";
              "Mod4+o" = "output 'eDP-1' toggle";
           };
            window.titlebar = false;
        };
    };
}
