{pkgs, ...}: {
  globals = {
    mapleader = " ";
  };

  opts = {
    number = true;
    relativenumber = true;
    cursorline = true;
    list = true;
    hlsearch = true;
    incsearch = true;
    ignorecase = true;
    smartcase = true;
    backup = false;
    swapfile = false;
    splitbelow = true;
    splitright = true;
    expandtab = true;
    smarttab = true;
    shiftwidth = 2;
    tabstop = 2;
    autoindent = true;
  };

  colorschemes.catppuccin = {
    enable = true;
    settings.flavour = "macchiato";
  };

  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>ff" = "git_files";
      "<leader>fg" = "live_grep";
    };
  };

  plugins.lsp = {
    enable = true;
    servers = {
      nil_ls.enable = true;
      solargraph.enable = true;
    };

    keymaps = {
      extra = [
        {
          mode = "n";
          key = "gr";
          action.__raw = "require('telescope.builtin').lsp_references";
        }
        {
          mode = "n";
          key = "gd";
          action.__raw = "require('telescope.builtin').lsp_definitions";
        }
      ];
    };
  };

  plugins.mini = {
    enable = true;
    modules = {
      statusline = {};
    };
  };

  plugins.web-devicons.enable = true;

  plugins.treesitter = {
    enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      json
      nix
      yaml
      markdown
      vim
      regex
      lua
      markdown_inline
    ];
  };

  plugins.noice.enable = true;
  plugins.snacks.enable = true;

  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
      formatters_by_ft = {
        nix = ["alejandra"];
      };
    };
  };
  plugins.blink-cmp.enable = true;

  plugins.gitsigns.enable = true;

  plugins.neo-tree.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
    }
    {
      mode = "i";
      key = "<C-h>";
      action = "<Left>";
    }
    {
      mode = "i";
      key = "<C-j>";
      action = "<Down>";
    }
    {
      mode = "i";
      key = "<C-k>";
      action = "<Up>";
    }
    {
      mode = "i";
      key = "<C-l>";
      action = "<Right>";
    }
    {
      mode = "i";
      key = "jj";
      action = "<Esc>";
    }

    {
      mode = "n";
      key = "<Leader>vh";
      action = ":new<CR>";
    }
    {
      mode = "n";
      key = "<Leader>vv";
      action = ":vnew<CR>";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
    }

    {
      mode = "n";
      key = "<leader>bn";
      action = ":bn<CR>";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = ":bp<CR>";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = ":bd<CR>";
    }
    {
      mode = "n";
      key = "\\";
      action = ":Neotree reveal toggle<CR>";
    }
  ];
}
