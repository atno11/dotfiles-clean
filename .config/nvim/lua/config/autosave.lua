-- Save modified files after 2 seconds without text changes.
-- Uses Neovim's native timer; no external plugin required.

local uv = vim.uv

local AUTOSAVE_DELAY_MS = 2000
local RETRY_DELAY_MS = 250

local timers = {}

local function can_save(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  local options = vim.bo[bufnr]

  return options.buftype == ''
    and options.buflisted
    and options.modifiable
    and not options.readonly
    and options.modified
    and vim.api.nvim_buf_get_name(bufnr) ~= ''
end

local function close_timer(bufnr)
  local state = timers[bufnr]

  if not state then
    return
  end

  timers[bufnr] = nil

  state.timer:stop()
  state.timer:close()
end

local schedule_save

local function save_buffer(bufnr)
  if not can_save(bufnr) then
    return
  end

  -- Do not interrupt completion or command-line editing.
  local mode = vim.api.nvim_get_mode().mode

  if vim.fn.pumvisible() == 1 or mode:sub(1, 1) == 'c' then
    schedule_save(bufnr, RETRY_DELAY_MS)
    return
  end

  -- :update writes only modified buffers and preserves write autocommands.
  local ok, err = pcall(function()
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd 'silent update'
    end)
  end)

  if not ok then
    vim.notify(
      string.format(
        'AutoSave: não foi possível salvar %s: %s',
        vim.api.nvim_buf_get_name(bufnr),
        tostring(err)
      ),
      vim.log.levels.WARN
    )
  end
end

schedule_save = function(bufnr, delay)
  local state = timers[bufnr]

  if not state then
    state = {
      timer = assert(uv.new_timer()),
      generation = 0,
    }

    timers[bufnr] = state
  end

  state.generation = state.generation + 1

  local generation = state.generation

  state.timer:stop()

  state.timer:start(delay, 0, vim.schedule_wrap(function()
    -- Ignore callbacks superseded by subsequent edits.
    if timers[bufnr] ~= state then
      return
    end

    if state.generation ~= generation then
      return
    end

    save_buffer(bufnr)
  end))
end

local group = vim.api.nvim_create_augroup('atno-autosave', {
  clear = true,
})

vim.api.nvim_create_autocmd({
  'TextChanged',
  'TextChangedI',
  'TextChangedP',
}, {
  group = group,
  desc = 'Save modified files after 2 seconds of inactivity',
  callback = function(args)
    if can_save(args.buf) then
      schedule_save(args.buf, AUTOSAVE_DELAY_MS)
    end
  end,
})

vim.api.nvim_create_autocmd({
  'BufUnload',
  'BufWipeout',
}, {
  group = group,
  desc = 'Release AutoSave timers when buffers are unloaded',
  callback = function(args)
    close_timer(args.buf)
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  desc = 'Release AutoSave timers on exit',
  callback = function()
    for bufnr in pairs(timers) do
      close_timer(bufnr)
    end
  end,
})
