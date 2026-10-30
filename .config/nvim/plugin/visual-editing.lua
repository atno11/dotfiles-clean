-- Editing actions for characterwise and linewise Visual selections.
local function selection()
  local anchor = vim.fn.getpos('v')
  local cursor = vim.fn.getpos('.')
  local first, last = { anchor[2], anchor[3] }, { cursor[2], cursor[3] }
  if first[1] > last[1] or (first[1] == last[1] and first[2] > last[2]) then
    first, last = last, first
  end
  return first, last, vim.fn.mode()
end

local function reselect(first, last, mode)
  vim.fn.setpos("'<", { 0, first[1], first[2], 0 })
  vim.fn.setpos("'>", { 0, last[1], last[2], 0 })
  vim.cmd('normal! gv')
  if mode == 'V' and vim.fn.mode() ~= 'V' then vim.cmd('normal! V') end
end

local function char_width(line, col)
  return #vim.fn.strcharpart(line:sub(col), 0, 1)
end

local function wrap(open, close)
  local first, last, mode = selection()
  if mode ~= 'v' and mode ~= 's' then return end
  local buf = vim.api.nvim_get_current_buf()
  local end_line = vim.api.nvim_buf_get_lines(buf, last[1] - 1, last[1], false)[1]
  local end_col = last[2] - 1
  if vim.o.selection ~= 'exclusive' then end_col = end_col + char_width(end_line, last[2]) end
  vim.api.nvim_buf_set_text(buf, last[1] - 1, end_col, last[1] - 1, end_col, { close })
  vim.cmd('undojoin')
  vim.api.nvim_buf_set_text(buf, first[1] - 1, first[2] - 1, first[1] - 1, first[2] - 1, { open })
end

for open, close in pairs({ ['('] = ')', ['{'] = '}', ['['] = ']' }) do
  vim.keymap.set('x', open, function() wrap(open, close) end, { desc = 'Wrap selection with ' .. open .. close })
  vim.keymap.set('s', open, function() wrap(open, close) end, { desc = 'Wrap selection with ' .. open .. close })
end

local function move_vertical(direction)
  local first, last, mode = selection()
  local buf = vim.api.nvim_get_current_buf()
  local count = vim.api.nvim_buf_line_count(buf)
  if direction < 0 and first[1] == 1 or direction > 0 and last[1] == count then return end
  local destination = direction < 0 and first[1] - 2 or last[1] + 1
  vim.cmd(('%d,%dmove %d'):format(first[1], last[1], destination))
  reselect({ first[1] + direction, first[2] }, { last[1] + direction, last[2] }, mode)
end

local function move_horizontal(direction)
  local first, last, mode = selection()
  if mode ~= 'v' or first[1] ~= last[1] then return end
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_buf_get_lines(buf, first[1] - 1, first[1], false)[1]
  local start_col = first[2] - 1
  local end_col = last[2] - 1
  if vim.o.selection ~= 'exclusive' then end_col = end_col + char_width(line, last[2]) end
  local selected = line:sub(start_col + 1, end_col)
  local before, after = line:sub(1, start_col), line:sub(end_col + 1)
  local new_start
  if direction < 0 then
    if start_col == 0 then return end
    local previous = vim.fn.strcharpart(before, vim.fn.strchars(before) - 1, 1)
    local prefix = before:sub(1, #before - #previous)
    line = prefix .. selected .. previous .. after
    new_start = start_col - #previous
  else
    if after == '' then return end
    local next_char = vim.fn.strcharpart(after, 0, 1)
    line = before .. next_char .. selected .. after:sub(#next_char + 1)
    new_start = start_col + #next_char
  end
  vim.api.nvim_buf_set_lines(buf, first[1] - 1, first[1], false, { line })
  reselect({ first[1], new_start + 1 }, { last[1], new_start + (last[2] - first[2]) + 1 }, mode)
end

vim.keymap.set('x', '<Up>', function() move_vertical(-1) end, { desc = 'Move selected lines up' })
vim.keymap.set('x', '<Down>', function() move_vertical(1) end, { desc = 'Move selected lines down' })
vim.keymap.set('x', '<Left>', function() move_horizontal(-1) end, { desc = 'Move selection left on one line' })
vim.keymap.set('x', '<Right>', function() move_horizontal(1) end, { desc = 'Move selection right on one line' })
