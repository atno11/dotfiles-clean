-- ============================================================
-- DIAGNOSTIC DISPLAY
-- Native virtual lines with word wrapping for Neovim 0.12
-- ============================================================

local api = vim.api

-- Wrap one paragraph without splitting words unnecessarily.
local function wrap_paragraph(paragraph, max_width)
  if paragraph == '' then
    return { '' }
  end

  local lines = {}
  local start = 0
  local total = vim.fn.strchars(paragraph)

  while start < total do
    local index = start
    local used_width = 0
    local last_space = nil

    while index < total do
      local char = vim.fn.strcharpart(paragraph, index, 1)
      local char_width = vim.fn.strdisplaywidth(char)

      if used_width + char_width > max_width then
        break
      end

      used_width = used_width + char_width

      if char:match('%s') then
        last_space = index
      end

      index = index + 1
    end

    if index == total then
      lines[#lines + 1] = vim.fn.strcharpart(paragraph, start)
      break
    end

    local finish

    if last_space and last_space > start then
      finish = last_space
    else
      finish = math.max(index, start + 1)
    end

    lines[#lines + 1] = vim.fn.strcharpart(
      paragraph,
      start,
      finish - start
    )

    start = finish

    -- Skip whitespace at the beginning of a wrapped line.
    while start < total do
      local char = vim.fn.strcharpart(paragraph, start, 1)

      if not char:match('%s') then
        break
      end

      start = start + 1
    end
  end

  return lines
end

-- Calculate the available width of windows displaying this buffer.
local function diagnostic_width(diagnostic)
  local width = vim.o.columns
  local bufnr = diagnostic.bufnr or 0

  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    if api.nvim_win_is_valid(winid) then
      width = math.min(width, api.nvim_win_get_width(winid))
    end
  end

  -- Reserve space for diagnostic indentation and connectors.
  return math.max(12, width - (diagnostic.col or 0) - 12)
end

-- Format the diagnostic before passing it to virtual_lines.
local function format_diagnostic(diagnostic)
  local message = diagnostic.message

  if diagnostic.code then
    message = tostring(diagnostic.code) .. ': ' .. message
  end

  local max_width = diagnostic_width(diagnostic)
  local lines = {}

  -- Preserve existing line breaks.
  for _, paragraph in ipairs(vim.split(message, '\n', { plain = true })) do
    vim.list_extend(lines, wrap_paragraph(paragraph, max_width))
  end

  return table.concat(lines, '\n')
end

vim.diagnostic.config {
  virtual_text = false,

  virtual_lines = {
    current_line = true,
    format = format_diagnostic,
  },
}

-- Recalculate wrapping when window dimensions change.
api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
  group = api.nvim_create_augroup('atno-diagnostic-display', { clear = true }),
  callback = function()
    vim.diagnostic.show()
  end,
})
