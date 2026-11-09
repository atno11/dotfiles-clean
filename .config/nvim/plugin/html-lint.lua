-- HTML and Markdown linting.
-- Loaded automatically by Neovim.

local gh = require 'plugins.github'

vim.pack.add { gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'

lint.linters_by_ft.html = { 'htmlhint' }
lint.linters_by_ft.markdown = { 'markdownlint' }

local group = vim.api.nvim_create_augroup('nvim-lint', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = group,
  callback = function(event)
    if not vim.bo[event.buf].modifiable then return end

    local filetype = vim.bo[event.buf].filetype
    if not lint.linters_by_ft[filetype] then return end

    lint.try_lint()
  end,
})
