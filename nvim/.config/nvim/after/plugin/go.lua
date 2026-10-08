-- ============================================================
-- GO DEVELOPMENT
-- Kickstart.nvim / Neovim 0.11+
-- ============================================================

-- Mark this module as loaded for diagnostics.
vim.g.go_module_loaded = true

-- ============================================================
-- 1. LSP - GOPLS
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

vim.lsp.enable('gopls')

-- ============================================================
-- 2. FORMATTING - CONFORM
-- ============================================================

local conform = require('conform')

-- Extend the existing formatter table.
-- Preserve C#, Lua, JSON and all other languages.
conform.formatters_by_ft.go = { 'goimports' }

local format_group = vim.api.nvim_create_augroup(
  'kickstart-go-format',
  { clear = true }
)

vim.api.nvim_create_autocmd('BufWritePre', {
  group = format_group,
  pattern = '*.go',
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'go' then
      return
    end

    conform.format({
      bufnr = args.buf,
      async = false,
      timeout_ms = 3000,
      lsp_format = 'fallback',
    })
  end,
})

-- ============================================================
-- 3. DEBUGGING - NVIM-DAP + DELVE
-- ============================================================

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

local debug_group = vim.api.nvim_create_augroup(
  'kickstart-go-debug',
  { clear = true }
)

local function configure_debug_keymaps(bufnr)
  local function opts(description)
    return {
      buffer = bufnr,
      desc = 'Go Debug: ' .. description,
    }
  end

  vim.keymap.set(
    'n',
    '<F5>',
    dap.continue,
    opts('Start / Continue')
  )

  -- F2 remains reserved for LSP Rename.
  vim.keymap.set(
    'n',
    '<F6>',
    dap.step_over,
    opts('Step Over')
  )

  vim.keymap.set(
    'n',
    '<F1>',
    dap.step_into,
    opts('Step Into')
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
end

vim.api.nvim_create_autocmd('FileType', {
  group = debug_group,
  pattern = 'go',
  callback = function(args)
    configure_debug_keymaps(args.buf)
  end,
})

-- Handle Go buffers already open when this module loads.
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_valid(bufnr)
      and vim.bo[bufnr].filetype == 'go' then
    configure_debug_keymaps(bufnr)
  end
end
