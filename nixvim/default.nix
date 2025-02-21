{ config, pkgs, inputs, ... }:
{
  programs.nixvim = {
    enable = true; 
    luaLoader.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
#    colorschemes.catppuccin.enable = true;

    plugins.cmp = {
      enable = true;

      settings = {

        completion = {
	  completeopt = "menu,menuone,noinsert";
	};

	sources = [
	  { 
	     name = "nvim_lsp";
	  }
	  {
	    name = "path";
	  }
	];

	mapping = {
	  "C-n" = "cmp.mapping.select_next_item()";
	  "C-p" = "cmp.mapping.select_prev_item()";
	  "C-b" = "cmp.mapping.scroll_docs(-4)";
	  "C-f" = "cmp.mapping.scroll_docs(4)";
	  "C-y" = "cmp.mapping.confirm { select = true }";
	};
      };
    };

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-path.enable = true;

    plugins.lsp = {
      enable = true; 

      servers = {
        nil_ls.enable = true;
      };
    };
  };
}
