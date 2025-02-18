{ config, pkgs, inputs, ... }:
{
  programs.nixvim = {
    enable = true; 
    luaLoader.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
#    colorschemes.catppuccin.enable = true;
  };
}
