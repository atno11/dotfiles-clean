-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', {
  desc = 'NeoTree reveal',
  silent = true,
})

local preview_config = {
  use_float = true,
  use_snacks_image = false,
  use_image_nvim = false,
}

-- Start a floating preview on the first navigation movement.
-- Neo-tree updates the active preview on subsequent movements.
local function move_with_preview(key)
  return function(state)
    vim.cmd.normal { key, bang = true }

    local preview = require('neo-tree.sources.common.preview')

    if preview.is_active() then
      return
    end

    local node = state.tree:get_node()

    if not node or node.type ~= 'file' then
      return
    end

    state.config = vim.deepcopy(preview_config)
    state.commands.toggle_preview(state)
  end
end

-- Expand a closed directory without toggling an already expanded one.
local function expand_closed_directory(state)
  local node = state.tree:get_node()

  if node and node.type == 'directory' and not node:is_expanded() then
    state.commands.open(state)
  end
end

require('neo-tree').setup {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',

        ['d'] = 'add_directory',
        ['f'] = 'add',

        -- Automatic preview with Vim navigation keys.
        ['j'] = move_with_preview('j'),
        ['k'] = move_with_preview('k'),

        -- Automatic preview with arrow keys.
        ['<Down>'] = move_with_preview('j'),
        ['<Up>'] = move_with_preview('k'),
        ['<Right>'] = expand_closed_directory,
        ['<Left>'] = 'close_node',

        ['<CR>'] = 'open',

        ['P'] = {
          'toggle_preview',
          config = preview_config,
        },
      },
    },
  },

  event_handlers = {
    {
      event = 'file_opened',
      handler = function()
        require('neo-tree.command').execute {
          action = 'close',
          source = 'filesystem',
        }
      end,
    },
  },
}
