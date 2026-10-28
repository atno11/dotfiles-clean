do
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- Move current line up/down like VS Code
  vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', { desc = 'Move line up' })
  vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', { desc = 'Move line down' })

  -- Move visual selection up/down like VS Code
  vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
  vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

  -- Indent visual selection with Tab / Shift+Tab
  vim.keymap.set('v', '<Tab>', '>gv', { desc = 'Indent selection' })
  vim.keymap.set('v', '<S-Tab>', '<gv', { desc = 'Unindent selection' })

  -- Insert line below like VS Code
  vim.keymap.set('n', '<C-CR>', 'o', {
    desc = 'Insert line below',
  })

  vim.keymap.set('i', '<C-CR>', '<Esc>o', {
    desc = 'Insert line below',
  })

  -- Insert line above like VS Code
  vim.keymap.set('n', '<C-S-CR>', 'O', {
    desc = 'Insert line above',
  })

  vim.keymap.set('i', '<C-S-CR>', '<Esc>O', {
    desc = 'Insert line above',
  })

  -- ============================================================
  -- VS Code-like keymaps
  -- ============================================================

  -- Save
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', {
    desc = 'Save file',
  })

  -- Quick Open
  vim.keymap.set('n', '<C-p>', function() require('telescope.builtin').find_files() end, {
    desc = 'Quick open file',
  })

  -- Command Palette
  vim.keymap.set('n', '<C-S-p>', function() require('telescope.builtin').commands() end, {
    desc = 'Command palette',
  })

  -- Search across project
  vim.keymap.set('n', '<C-S-f>', function() require('telescope.builtin').live_grep() end, {
    desc = 'Search project',
  })

  -- Rename symbol
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, {
    desc = 'Rename symbol',
  })

  -- Go to definition
  vim.keymap.set('n', '<F12>', function() require('telescope.builtin').lsp_definitions() end, {
    desc = 'Go to definition',
  })

  -- Find references
  vim.keymap.set('n', '<F24>', function() require('telescope.builtin').lsp_references() end, {
    desc = 'Find references',
  })

  -- Quick Fix / Code Action
  vim.keymap.set({ 'n', 'v' }, '<C-.>', vim.lsp.buf.code_action, {
    desc = 'Code action',
  })

  -- Format document
  vim.keymap.set({ 'n', 'v' }, '<A-S-f>', function() require('conform').format { async = true } end, {
    desc = 'Format document',
  })

  -- Switch editors / buffers
  vim.keymap.set('n', '<A-Left>', '<cmd>bprevious<CR>', {
    desc = 'Previous buffer',
  })

  vim.keymap.set('n', '<A-Right>', '<cmd>bnext<CR>', {
    desc = 'Next buffer',
  })

  -- Toggle comment
  -- Ctrl+/ is commonly sent by terminals as Ctrl+_
  vim.keymap.set('n', '<C-_>', 'gcc', {
    remap = true,
    desc = 'Toggle comment',
  })

  vim.keymap.set('v', '<C-_>', 'gc', {
    remap = true,
    desc = 'Toggle comment selection',
  })

  -- Duplicate current line
  vim.keymap.set('n', '<A-S-Down>', 'yyp', {
    desc = 'Duplicate line down',
  })

  vim.keymap.set('n', '<A-S-Up>', 'yyP', {
    desc = 'Duplicate line up',
  })
  -- Select all like VS Code
  vim.keymap.set('n', '<C-a>', 'ggVG', {
    desc = 'Select all',
  })

  vim.keymap.set('i', '<C-a>', '<Esc>ggVG', {
    desc = 'Select all',
  })

  vim.keymap.set('x', '<C-a>', '<Esc>ggVG', {
    desc = 'Select all',
  })

  vim.keymap.set('n', '<C-S-o>', function() require('telescope.builtin').lsp_document_symbols() end, {
    desc = 'Go to symbol in file',
  })

  -- Delete word forward when cursor is at the beginning
  vim.keymap.set('i', '<C-BS>', '<C-o>de', {
    desc = 'Delete word forward',
  })

  -- Delete previous word when cursor is at the end
  vim.keymap.set('i', '<A-BS>', '<C-g>u<C-w>', {
    desc = 'Delete previous word',
  })

  -- Delete current line
  vim.keymap.set('n', '<S-BS>', '"_dd', {
    desc = 'Delete current line',
  })
  vim.keymap.set('i', '<S-BS>', '<C-o>"_dd', {
    desc = 'Delete current line',
  })

end
