-- Smart Ctrl+Backspace for Insert and Command-line modes.
-- Delete filename/path segments while keeping separators
-- as individual deletion steps.

local function deletion_length(prefix)
  if prefix == '' then
    return 0
  end

  local last = prefix:sub(-1)

  if last == '.' or last == '/' then
    return 1
  end

  local segment = prefix:match('[^./%s]+$')

  if segment then
    return vim.fn.strchars(segment)
  end

  local whitespace = prefix:match('%s+$')

  if whitespace then
    return vim.fn.strchars(whitespace)
  end

  return 1
end

local function delete_insert_segment()
  local line = vim.api.nvim_get_current_line()
  local column = vim.fn.col('.') - 1
  local prefix = line:sub(1, column)

  return string.rep('<BS>', deletion_length(prefix))
end

local function delete_command_segment()
  local command = vim.fn.getcmdline()
  local column = vim.fn.getcmdpos() - 1
  local prefix = command:sub(1, column)

  return string.rep('<BS>', deletion_length(prefix))
end

vim.keymap.set('i', '<C-BS>', delete_insert_segment, {
  expr = true,
  replace_keycodes = true,
  desc = 'Delete previous filename or path segment',
})

vim.keymap.set('c', '<C-BS>', delete_command_segment, {
  expr = true,
  replace_keycodes = true,
  desc = 'Delete previous command-line segment',
})
