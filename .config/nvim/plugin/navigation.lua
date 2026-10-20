-- Custom arrow navigation and clipboard shortcuts.

-- Allow horizontal arrows to cross line boundaries.
vim.opt.whichwrap:append('<,>,[,]')

-- Track blank lines created by arrow navigation.
local namespace = vim.api.nvim_create_namespace('atno.navigation')
local generated_lines = {}

local function can_modify()
  return vim.bo.buftype == ''
    and vim.bo.modifiable
    and not vim.bo.readonly
end

local function feed_key(key)
  vim.api.nvim_feedkeys(vim.keycode(key), 'n', false)
end

-- Append at most one blank line at the end of a buffer.
local function append_blank_line()
  if not can_modify() then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()
  local last = vim.api.nvim_buf_line_count(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)

  if cursor[1] ~= last then
    return false
  end

  -- Do not append after an already empty line.
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return false
  end

  local previous = generated_lines[buf]

  if previous then
    vim.api.nvim_buf_del_extmark(buf, namespace, previous)
  end

  vim.api.nvim_buf_set_lines(buf, last, last, false, { '' })

  generated_lines[buf] = vim.api.nvim_buf_set_extmark(
    buf,
    namespace,
    last,
    0,
    { invalidate = true }
  )

  vim.api.nvim_win_set_cursor(0, { last + 1, 0 })

  return true
end

-- Remove a trailing empty line.
-- When only_generated is true, require the navigation marker.
local function remove_last_blank_line(only_generated)
  if not can_modify() then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()
  local last = vim.api.nvim_buf_line_count(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)

  -- Keep at least one line in the buffer.
  if last <= 1 or cursor[1] ~= last then
    return false
  end

  -- Never delete a line containing text.
  if vim.api.nvim_get_current_line() ~= '' then
    return false
  end

  local mark_id = generated_lines[buf]

  if only_generated then
    if not mark_id then
      return false
    end

    local mark = vim.api.nvim_buf_get_extmark_by_id(
      buf,
      namespace,
      mark_id,
      { details = true }
    )

    if not mark[1]
      or mark[1] ~= last - 1
      or (mark[3] and mark[3].invalid)
    then
      return false
    end
  end

  -- Clear the navigation marker, when present.
  if mark_id then
    vim.api.nvim_buf_del_extmark(buf, namespace, mark_id)
    generated_lines[buf] = nil
  end

  vim.api.nvim_buf_set_lines(buf, last - 1, last, false, {})
  vim.api.nvim_win_set_cursor(0, { last - 1, 0 })

  return true
end

-- Normal mode: Down.
vim.keymap.set('n', '<Down>', function()
  if not append_blank_line() then
    feed_key('<Down>')
  end
end, {
  desc = 'Move down or append one blank line',
})

-- Insert mode: Down.
vim.keymap.set('i', '<Down>', function()
  local cmp = package.loaded['blink.cmp']

  if cmp and cmp.is_visible() then
    cmp.select_next()
    return
  end

  if not append_blank_line() then
    feed_key('<Down>')
  end
end, {
  desc = 'Move down or append one blank line',
})

-- Normal mode: Up removes only generated blank lines.
vim.keymap.set('n', '<Up>', function()
  if not remove_last_blank_line(true) then
    feed_key('<Up>')
  end
end, {
  desc = 'Move up or remove generated blank line',
})

-- Insert mode: Up.
vim.keymap.set('i', '<Up>', function()
  if not remove_last_blank_line(true) then
    feed_key('<Up>')
  end
end, {
  desc = 'Move up or remove generated blank line',
})

-- Normal mode: Backspace deletes the previous character.
-- At column zero, join with the previous line.
vim.keymap.set('n', '<BS>', function()
  if not can_modify() then
    feed_key('<BS>')
    return
  end

  -- Remove a trailing empty line first.
  if remove_last_blank_line(false) then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]

  -- Delete the previous character using native Vim behavior.
  if col > 0 then
    vim.cmd('normal! X')
    return
  end

  -- Nothing to delete at the beginning of the buffer.
  if row <= 1 then
    return
  end

  -- Join the current line with the previous line.
  local lines = vim.api.nvim_buf_get_lines(
    buf,
    row - 2,
    row,
    false
  )

  local previous = lines[1]
  local current = lines[2]

  vim.api.nvim_buf_set_lines(
    buf,
    row - 2,
    row,
    false,
    { previous .. current }
  )

  vim.api.nvim_win_set_cursor(0, {
    row - 1,
    #previous,
  })
end, {
  desc = 'Delete previous character or join lines',
})

-- Copy to the system clipboard.
vim.keymap.set('n', '<C-S-c>', '"+yy', {
  desc = 'Copy current line',
})

vim.keymap.set('x', '<C-S-c>', '"+y', {
  desc = 'Copy selection',
})

vim.keymap.set('i', '<C-S-c>', '<C-o>"+yy', {
  desc = 'Copy current line',
})

-- Cut to the system clipboard.
vim.keymap.set('n', '<C-S-x>', '"+dd', {
  desc = 'Cut current line',
})

vim.keymap.set('x', '<C-S-x>', '"+d', {
  desc = 'Cut selection',
})

vim.keymap.set('i', '<C-S-x>', '<C-o>"+dd', {
  desc = 'Cut current line',
})
