-- ============================================================
-- TYPESCRIPT AND JAVASCRIPT DEVELOPMENT
-- Neovim 0.11+ / Mason / Conform
-- ============================================================

-- ============================================================
-- 1. LANGUAGE SERVER
-- ============================================================

-- Uses the ts_ls configuration provided by nvim-lspconfig.
-- Supports JavaScript, JSX, TypeScript and TSX.
vim.lsp.enable('ts_ls')

-- ============================================================
-- 2. MASON TOOLCHAIN
-- ============================================================

local registry = require('mason-registry')
local package_name = 'typescript-language-server'

registry.refresh(function()
  if not registry.has_package(package_name) then
    vim.schedule(function()
      vim.notify(
        'TypeScript: Mason package not found: ' .. package_name,
        vim.log.levels.ERROR
      )
    end)
    return
  end

  local package = registry.get_package(package_name)

  if package:is_installed() or package:is_installing() then
    return
  end

  local ok, err = pcall(function()
    package:install({}, function(success, result)
      if not success then
        vim.schedule(function()
          vim.notify(
            'TypeScript: installation failed: '
              .. vim.inspect(result),
            vim.log.levels.ERROR
          )
        end)
      end
    end)
  end)

  if not ok then
    vim.schedule(function()
      vim.notify(
        'TypeScript: unable to start installation: '
          .. tostring(err),
        vim.log.levels.ERROR
      )
    end)
  end
end)

-- ============================================================
-- 3. FORMATTING - CONFORM + PRETTIER
-- ============================================================

local conform = require('conform')

-- Extend the existing formatter configuration.
-- Preserve Go, C#, Lua, JSON and other languages.
conform.formatters_by_ft.javascript = { 'prettier' }
conform.formatters_by_ft.javascriptreact = { 'prettier' }
conform.formatters_by_ft.typescript = { 'prettier' }
conform.formatters_by_ft.typescriptreact = { 'prettier' }

-- ============================================================
-- 4. FORMAT ON SAVE
-- ============================================================

local supported_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local format_group = vim.api.nvim_create_augroup(
  'kickstart-typescript-format',
  { clear = true }
)

vim.api.nvim_create_autocmd('BufWritePre', {
  group = format_group,
  callback = function(args)
    if not supported_filetypes[vim.bo[args.buf].filetype] then
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
