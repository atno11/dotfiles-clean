do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = false

  -- Make line numbers default
  vim.o.number = true

  -- Enable mouse mode
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Set terminal/tab title to the current file name
  vim.o.title = true
  vim.o.titlestring = '%t'

  -- Enable break indent
  vim.o.breakindent = true

  -- Persistent undo
  vim.o.undofile = true

  -- Smart case-insensitive searching
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn visible
  vim.o.signcolumn = 'yes'

  -- Faster updates
  vim.o.updatetime = 250

  -- Key sequence timeout
  vim.o.timeoutlen = 300

  -- Split behavior
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Whitespace visualization
  vim.o.list = true
  vim.opt.listchars = {
    tab = '» ',
    trail = '·',
    nbsp = '␣',
  }

  -- Preview substitutions
  vim.o.inccommand = 'split'

  -- Highlight current line
  vim.o.cursorline = true

  -- Keep context around cursor
  vim.o.scrolloff = 10

  -- Ask before discarding unsaved changes
  vim.o.confirm = true
end
