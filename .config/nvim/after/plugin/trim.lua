

-- ============================================================
-- TRIM.NVIM - WHITESPACE CLEANUP
-- ============================================================
-- Automatically removes unnecessary whitespace and blank
-- lines at the beginning and end of files on save.
--
-- Commands:
--   :Trim       - Clean the current buffer manually
--   :TrimToggle - Toggle automatic cleanup
--
-- Markdown is excluded to preserve intentional line breaks.
-- ============================================================

vim.pack.add({
  'https://github.com/cappyzawa/trim.nvim',
})

require('trim').setup({
  trim_on_write = true,

  -- Remove trailing whitespace from every line.
  trim_trailing = true,
  trim_current_line = true,

  -- Remove unnecessary blank lines at file boundaries.
  trim_first_line = true,
  trim_last_line = true,

  -- Preserve intentional spacing in Markdown.
  ft_blocklist = {
    'markdown',
  },

  -- Do not collapse blank lines inside code.
  patterns = {},

  highlight = false,
  notifications = true,
})
