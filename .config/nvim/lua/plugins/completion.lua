local gh = require 'plugins.github'

do
  -- [[ Snippet Engine ]]

  -- NOTE: You can also specify plugin using a version range for its git tag.
  --  See `:help vim.version.range()` for more info
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  local function import_origin(ctx)
    local item = ctx.item
    local client = item.client_id and vim.lsp.get_client_by_id(item.client_id)
    if client and client.name == 'tailwindcss' then return '' end
    if ctx.label_description ~= '' then return ctx.label_description end
    if item.source_id ~= 'lsp' or not client or client.name ~= 'ts_ls' then return '' end

    -- The TypeScript server prefixes actionable autoimports and puts their module in detail.
    local data = item.data
    local autoimport_prefix = '￿'
    if type(data) == 'table' and type(data.cacheId) == 'number'
      and type(item.sortText) == 'string' and item.sortText:sub(1, #autoimport_prefix) == autoimport_prefix
      and type(item.detail) == 'string' then
      return item.detail
    end
    return ''
  end

  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'enter',
      ['<C-Space>'] = { 'show' },
      ['<C-S-CR>'] = { 'fallback' },
      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      trigger = { show_on_keyword = false, show_on_trigger_character = false },
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
      menu = {
        draw = {
          columns = {
            { 'label', 'import_origin', gap = 1 },
            { 'kind_icon', 'kind' },
          },
          components = {
            import_origin = { text = import_origin, highlight = 'BlinkCmpLabelDetail' },
          },
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },

      per_filetype = {
        typescript = { 'lsp', 'snippets' },
        typescriptreact = { 'lsp', 'snippets' },
        javascript = { 'lsp', 'snippets' },
        javascriptreact = { 'lsp', 'snippets' },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
vim.pack.add { gh 'windwp/nvim-autopairs' }

require('nvim-autopairs').setup {
  check_ts = true,
  enable_check_bracket_line = false,
}
end
