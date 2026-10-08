-- ============================================================
-- GO DEVELOPMENT
-- Kickstart.nvim / Neovim 0.11+
--
-- LSP:        gopls
-- Formatter:  goimports via conform.nvim
-- Debugger:   nvim-dap-go + Delve
--
-- Loaded automatically from after/plugin/go.lua.
-- Preserves existing C#, Lua and other language configurations.
-- ============================================================

-- ============================================================
-- 1. GO LANGUAGE SERVER
-- ============================================================

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = false,
      usePlaceholders = true,
      completeUnimported = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- Mason's automatic_enable is disabled in the main init.lua.
-- Enable gopls explicitly.
vim.lsp.enable('gopls')

-- ============================================================
-- 2. GO FORMATTING
-- ============================================================

local conform = require('conform')

-- Extend the existing configuration without resetting
-- CSharpier, StyLua, Prettier, or other formatters.
conform.formatters_by_ft.go = { 'goimports' }

-- Enable format-on-save for Go source files.
-- The main init.lua does not currently format Go on save.
local go_format_group = vim.api.nvim_create_augroup(
  'kickstart-go-format',
  { clear = true }
)

vim.api.nvim_create_autocmd('BufWritePre', {
  group = go_format_group,
  pattern = '*.go',

  callback = function(args)
    conform.format({
      bufnr = args.buf,
      timeout_ms = 3000,
      lsp_format = 'fallback',
    })
  end,
})

-- ============================================================
-- 3. GO DEBUGGING
-- ============================================================

-- The existing kickstart.plugins.debug module is not loaded
-- by init.lua. Install only the dependencies needed for Go
-- debugging here, avoiding the unknown configuration
-- inside that disabled module.
vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/leoluz/nvim-dap-go',
})

local dap = require('dap')

require('dap-go').setup({
  delve = {
    path = 'dlv',
  },
})

-- ============================================================
-- 4. GO-SPECIFIC DEBUG KEYMAPS
-- ============================================================

local go_debug_group = vim.api.nvim_create_augroup(
  'kickstart-go-debug',
  { clear = true }
)

vim.api.nvim_create_autocmd('FileType', {
  group = go_debug_group,
  pattern = 'go',

  callback = function(args)
    local opts = function(desc)
      return {
        buffer = args.buf,
        desc = 'Go Debug: ' .. desc,
      }
    end

    vim.keymap.set(
      'n',
      '<F5>',
      dap.continue,
      opts('Start/Continue')
    )

    vim.keymap.set(
      'n',
      '<F1>',
      dap.step_into,
      opts('Step Into')
    )

    vim.keymap.set(
      'n',
      '<F2>',
      dap.step_over,
      opts('Step Over')
    )

    vim.keymap.set(
      'n',
      '<F3>',
      dap.step_out,
      opts('Step Out')
    )

    vim.keymap.set(
      'n',
      '<leader>b',
      dap.toggle_breakpoint,
      opts('Toggle Breakpoint')
    )

    vim.keymap.set(
      'n',
      '<leader>dt',
      function()
        require('dap-go').debug_test()
      end,
      opts('Debug Test')
    )
  end,
})
