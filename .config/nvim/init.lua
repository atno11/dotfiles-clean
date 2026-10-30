-- Neovim 0.12 / vim.pack: keep this order when changing startup dependencies.
require 'config.options'
require 'config.diagnostics'
require 'config.keymaps'
require 'config.autocmds'

require 'plugins.manager' -- PackChanged build hooks must precede vim.pack.add.
require 'plugins.ui' -- Includes the Catppuccin setup at its original position.
require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.formatting'
require 'plugins.completion'
require 'plugins.treesitter'

-- This specialized module calls vim.pack.add and configures Neo-tree.
require 'kickstart.plugins.neo-tree'

-- The files in plugin/ and after/plugin/ are sourced by Neovim's runtime.
-- Optional examples in lua/kickstart/plugins/ and lua/custom/plugins/ stay inactive.
-- vim: ts=2 sts=2 sw=2 et
