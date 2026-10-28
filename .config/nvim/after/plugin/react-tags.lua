-- HTML/JSX/TSX: Emmet suggestions and automatic tag closing.
-- ts_ls, blink.cmp, Mason and Treesitter are configured in init.lua/typescript.lua.

vim.pack.add { 'https://github.com/windwp/nvim-ts-autotag' }
require('nvim-ts-autotag').setup {
  opts = {
    enable_close = true,
    enable_rename = true,
  },
}

-- Emmet expands abbreviations such as div.card into JSX/HTML markup.
-- Suggestions are handled by the existing blink.cmp LSP source.
vim.lsp.config('emmet_language_server', {
  filetypes = { 'html', 'javascriptreact', 'typescriptreact' },
})
vim.lsp.enable 'emmet_language_server'

-- Synchronize matching JSX/TSX tag names while typing (Neovim 0.12+).
vim.lsp.linked_editing_range.enable()

-- Install the Emmet server with Mason, following the TypeScript setup pattern.
local registry = require 'mason-registry'
local package_name = 'emmet-language-server'

registry.refresh(function()
  if not registry.has_package(package_name) then
    vim.schedule(function()
      vim.notify('Emmet: Mason package not found: ' .. package_name, vim.log.levels.ERROR)
    end)
    return
  end

  local package = registry.get_package(package_name)
  if package:is_installed() or package:is_installing() then return end

  local ok, err = pcall(function()
    package:install({}, function(success, result)
      if not success then
        vim.schedule(function()
          vim.notify('Emmet: installation failed: ' .. vim.inspect(result), vim.log.levels.ERROR)
        end)
      end
    end)
  end)

  if not ok then
    vim.schedule(function()
      vim.notify('Emmet: unable to start installation: ' .. tostring(err), vim.log.levels.ERROR)
    end)
  end
end)
