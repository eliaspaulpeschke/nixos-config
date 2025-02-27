{...}:
{
  programs.alacritty = {
    enable = true;
    settings = {

      font = {
        normal = { family = "GeistMono Nerd Font"; style = "Regular"; };
      };
      
      window = {
        padding = { x = 15; y = 15; }; 
        opacity = 0.9;
        blur = true;
      };

      bell = {
        animation = "Ease";
        duration = 100;
      };

      #https://github.com/alacritty/alacritty-theme/blob/master/themes/moonfly.toml

      colors.bright = {
        black = "#949494";
        blue = "#74b2ff";
        cyan = "#85dc85";
        green = "#36c692";
        magenta = "#ae81ff";
        red = "#ff5189";
        white = "#e4e4e4";
        yellow = "#c6c684";
     };
        
      colors.cursor={
        cursor = "#8e8e8e";
        text = "#080808";
      };
        
      colors.normal={
        black = "#323437";
        blue = "#80a0ff";
        cyan = "#79dac8";
        green = "#8cc85f";
        magenta = "#cf87e8";
        red = "#ff5454";
        white = "#c6c6c6";
        yellow = "#e3c78a";
      };

      colors.primary={
        background = "#080808";
        bright_foreground = "#eeeeee";
        foreground = "#bdbdbd";
      };
        
      colors.selection={
        background = "#b2ceee";
        text = "#080808";
      };
    };
  };
}
