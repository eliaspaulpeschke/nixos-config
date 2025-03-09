{ config, pkgs, inputs, ... }:
let
  helpers = config.lib.nixvim;
in
{
  programs.nixvim = {
    enable = true; 
    luaLoader.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
        expandtab = true;
        autoindent = true;
        smartindent = true;
        shiftwidth = 4;
    };
    plugins.web-devicons.enable = true;

    plugins.cmp = {
      enable = true;

      settings = {

        completion = {
	  completeopt = "menu,menuone,noinsert";
	};

	sources = [
	  { 
	     name = "nvim_lsp";
             priority = 10;
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
	hls = {
	  enable = true;
	  installGhc = false;
        };
      };
    };

    plugins.telescope = {
        enable = true;
        autoLoad = true;
        keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
            "<leader>fb" = "buffers";
            "<leader>fh" = "help_tags";
            "<leader>fs" = "grep_string";
        };
    };

    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "moonfly";
      src = pkgs.fetchFromGitHub {
        owner = "bluz71";
        repo = "vim-moonfly-colors";
        rev = "9b3d08ccd2152a9a6694ce64bd57b1e19662f3c9";
        hash = "sha256-1BurRJ0TnLSihXZXtr6BMGuvlYnnc3fER4oKQa+2E5w=";
      };
    })];

    extraConfigLua = ''

        vim.cmd [[colorscheme moonfly]]
        vim.cmd [[highlight Normal guibg=none ctermbg=none]]
        vim.cmd [[highlight LineNr guibg=none ctermbg=none]]
        vim.cmd [[highlight Folded guibg=none ctermbg=none]]
        vim.cmd [[highlight NonText guibg=none ctermbg=none]]
        vim.cmd [[highlight SpecialKey guibg=none ctermbg=none]]
        vim.cmd [[highlight VertSplit guibg=none ctermbg=none]]
        vim.cmd [[highlight SignColumn guibg=none ctermbg=none]]
        vim.cmd [[highlight EndOfBuffer guibg=none ctermbg=none]]
        vim.cmd [[highlight TablineFill guibg=none ctermbg=none]]

        require('lspconfig')['hls'].setup{
          filetypes = { 'haskell', 'lhaskell', 'cabal' }, 
        }
    '';

  };
}
