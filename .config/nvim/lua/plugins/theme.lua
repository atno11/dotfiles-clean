local gh = require 'plugins.github'

  vim.pack.add { gh 'catppuccin/nvim' }

  require('catppuccin').setup {
    flavour = 'mocha',
    integrations = {
      telescope = true,
      treesitter = true,
      gitsigns = true,
      mason = true,
      which_key = true,
      mini = true,
      navic = {
        enabled = true,
        custom_bg = 'NONE',
      },
    },
  }

  vim.cmd.colorscheme 'catppuccin-mocha'
