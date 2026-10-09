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

-- Return to Neo-tree only after saving a file opened from Neo-tree.
local return_group = vim.api.nvim_create_augroup(
  'neo-tree-return-on-save',
  { clear = true }
)

vim.api.nvim_create_autocmd('BufWritePost', {
  group = return_group,
  callback = function(args)
    if not vim.b[args.buf].neo_tree_return_on_save then
      return
    end

    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end

      -- Avoid switching away if another buffer gained focus.
      if vim.api.nvim_get_current_buf() ~= args.buf then
        return
      end

      require('neo-tree.command').execute {
        action = 'show',
        source = 'filesystem',
        reveal = true,
        focus = true,
      }
    end)
  end,
})

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

        -- The opened buffer becomes the active editing buffer.
        vim.schedule(function()
          local bufnr = vim.api.nvim_get_current_buf()

          if vim.bo[bufnr].buftype == '' then
            vim.b[bufnr].neo_tree_return_on_save = true
          end
        end)
      end,
    },
  },
}
