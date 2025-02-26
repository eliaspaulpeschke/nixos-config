{...}:
{
  programs.alacritty = {
    enable = true;
    settings = ''
      
      [window]
      padding = { x = 5, x = 5 } 
      opacity = 0.9
      blur = true

      [bell]
      animation = "Ease"
      duration = 0.1

    '';
  };
}
