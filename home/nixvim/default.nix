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

    plugins.texpresso = {
        enable = true;
    };

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
              name = "vimtex";
              priority = 7;
          }
          {
             name = "luasnip";
             priority = 5;
          }
	  {
	    name = "path";
	  }
	];


	mapping = {
	  "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),{'i','c'})";
	  "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),{'i','c'})";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
	  "<C-f>" = "cmp.mapping.scroll_docs(4)";
	  "<C-y>" = "cmp.mapping.confirm { select = true }";
          "<C-Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if luasnip.expandable() then 
                    luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                end
              end, {"i", "s"})'';
          };
	};
      };

    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp_luasnip.enable = true;
    plugins.cmp-vimtex.enable = true;

    plugins.vimtex = {
        enable = true;
        settings = {
            compiler_method = "latexrun";
            view_method = "zathura";
        };
    };

    plugins.lsp = {
      enable = true; 

      servers = {
        nil_ls.enable = true;
        uiua = {
            enable = true;
        #    filetypes = [ "uiua" ];
         #   rootMarkers = [ "main.ua" ".fmt.ua" ".git" ".uiua-root" ];
        };
	hls = {
	  enable = true;
	  installGhc = false;
        };
        clangd.enable = true;
      };

      keymaps.diagnostic = {
          "<C-d>" = "open_float";
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

    plugins.luasnip = {
        enable = true;
        autoLoad = true;
        filetypeExtend = {
            plaintex = [ "plaintex" "latex" "markdown" ];
            markdown = [ "latex" "markdown" ];
        };
        fromSnipmate = [ { paths = ./snippets; } ];
    };

    extraPlugins = [
       (pkgs.vimUtils.buildVimPlugin {
          name = "moonfly";
          src = pkgs.fetchFromGitHub {
            owner = "bluz71";
            repo = "vim-moonfly-colors";
            rev = "9b3d08ccd2152a9a6694ce64bd57b1e19662f3c9";
            hash = "sha256-1BurRJ0TnLSihXZXtr6BMGuvlYnnc3fER4oKQa+2E5w=";
          };
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "uiua";
          src = pkgs.fetchFromGitHub {
            owner = "Apeiros-46B";
            repo = "uiua.vim";
            rev = "99972deb001c7e527348c190d9e5b78abf6d574b";
            hash = "sha256-NfLZkyUAccVtZ0Rc0+o3PbgbI2L7ggM5VHq60cg/RXU=";
           };
        })
    ];

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

        vim.lsp.config['hls'].setup{
          filetypes = { 'haskell', 'lhaskell', 'cabal' }, 
        } 
        '';

      #  local ls = require("luasnip")
       # require("luasnip.loaders.from_snipmate").load({ path = { "${./snippets}" } })

  };
}
