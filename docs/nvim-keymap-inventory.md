# Neovim effective keymap inventory

Captured from the effective `~/.config/nvim` on Neovim 0.12.6. Global maps and buffer-local maps in Lua, Go, TypeScript, JSON, and Markdown sample buffers are included. `nvim_get_keymap` and `nvim_buf_get_keymap` supplied the effective maps; `:verbose map` supplied the runtime source. A callback RHS appears as `callback`; its description states intended behavior. `Lua` and `runtime/generated` sources are unresolved runtime provenance. Filetype and LSP attachment can add further buffer maps.

Mode is the effective API mode (`n`, `x`, `s`, `o`, `i`, `c`, or `t`). `global` or a filetype names the scope. For mappings with no description, intended behavior is inferred from the RHS only.

## Debug

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| go | n |  b | runtime/generated | Go Debug: Toggle Breakpoint | callback |
| go | n |  dt | runtime/generated | Go Debug: Debug Test | callback |
| go | n | <F1> | ~/.config/nvim/after/plugin/go.lua | Go Debug: Step Into | callback |
| go | n | <F3> | ~/.config/nvim/after/plugin/go.lua | Go Debug: Step Out | callback |
| go | n | <F5> | ~/.config/nvim/after/plugin/go.lua | Go Debug: Start / Continue | callback |
| go | n | <F6> | .config/nvim/after/plugin/go.lua | Go Debug: Step Over | callback |

## Editing and save

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | c | <C-BS> | .config/nvim/plugin/ctrl-backspace.lua | Delete previous command-line segment | callback |
| global | i | <C-BS> | .config/nvim/plugin/ctrl-backspace.lua | Delete previous filename or path segment | callback |
| global | i | <C-CR> | .config/nvim/lua/config/keymaps.lua | Insert line below | <Esc>o |
| global | i | <C-S-CR> | .config/nvim/lua/config/keymaps.lua | Insert line above | <Esc>O |
| global | i | <C-S> | .config/nvim/lua/config/keymaps.lua | Save file | <Cmd>w<CR> |
| global | i | <M-BS> | .config/nvim/lua/config/keymaps.lua | Delete previous word | <C-G>u<C-W> |
| global | i | <S-BS> | .config/nvim/lua/config/keymaps.lua | Delete current line | <C-O>"_dd |
| global | n | <BS> | .config/nvim/plugin/navigation.lua | Delete previous character or join lines | callback |
| global | n | <C-CR> | .config/nvim/lua/config/keymaps.lua | Insert line below | o |
| global | n | <C-S-CR> | .config/nvim/lua/config/keymaps.lua | Insert line above | O |
| global | n | <C-S> | .config/nvim/lua/config/keymaps.lua | Save file | <Cmd>w<CR> |
| global | n | <S-BS> | .config/nvim/lua/config/keymaps.lua | Delete current line | "_dd |
| global | n | sd | ~/.config/nvim/init.lua | Delete surrounding | callback |
| global | n | sdl | ~/.config/nvim/init.lua | Delete previous surrounding | callback |
| global | n | sdn | ~/.config/nvim/init.lua | Delete next surrounding | callback |
| global | s | <C-S> | .config/nvim/lua/config/keymaps.lua | Save file | <Cmd>w<CR> |
| global | x | <C-S> | .config/nvim/lua/config/keymaps.lua | Save file | <Cmd>w<CR> |
| go | i | <BS> | ~/.config/nvim/init.lua | autopairs delete | callback |
| json | i | <BS> | ~/.config/nvim/init.lua | autopairs delete | callback |
| lua | i | <BS> | ~/.config/nvim/init.lua | autopairs delete | callback |
| markdown | i | <BS> | ~/.config/nvim/init.lua | autopairs delete | callback |
| typescript | i | <BS> | ~/.config/nvim/init.lua | autopairs delete | callback |

## Formatting and indentation

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | n | <M-F> | .config/nvim/lua/config/keymaps.lua | Format document | callback |
| global | s | <M-F> | .config/nvim/lua/config/keymaps.lua | Format document | callback |
| global | s | <S-Tab> | .config/nvim/lua/config/keymaps.lua | Unindent selection | <lt>gv |
| global | s | <Tab> | .config/nvim/lua/config/keymaps.lua | Indent selection | >gv |
| global | x | <M-F> | .config/nvim/lua/config/keymaps.lua | Format document | callback |
| global | x | <S-Tab> | .config/nvim/lua/config/keymaps.lua | Unindent selection | <lt>gv |
| global | x | <Tab> | .config/nvim/lua/config/keymaps.lua | Indent selection | >gv |

## LSP and diagnostics

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | n |  q | .config/nvim/lua/config/keymaps.lua | Open diagnostic [Q]uickfix list | callback |
| global | n | <C-.> | .config/nvim/lua/config/keymaps.lua | Code action | callback |
| global | n | <C-S-O> | .config/nvim/lua/config/keymaps.lua | Go to symbol in file | callback |
| global | n | <F12> | .config/nvim/lua/config/keymaps.lua | Go to definition | callback |
| global | n | <F24> | .config/nvim/lua/config/keymaps.lua | Find references | callback |
| global | n | <F2> | .config/nvim/lua/config/keymaps.lua | Rename symbol | callback |
| global | n | [D | Lua | Jump to the first diagnostic in the current buffer | callback |
| global | n | [d | Lua | Jump to the previous diagnostic in the current buffer | callback |
| global | n | ]D | Lua | Jump to the last diagnostic in the current buffer | callback |
| global | n | ]d | Lua | Jump to the next diagnostic in the current buffer | callback |
| global | n | gO | .config/nvim/lua/plugins/telescope.lua | vim.lsp.buf.document_symbol() | callback |
| global | n | gra | Lua | vim.lsp.buf.code_action() | callback |
| global | n | gri | .config/nvim/lua/plugins/telescope.lua | vim.lsp.buf.implementation() | callback |
| global | n | grn | .config/nvim/lua/plugins/lsp.lua | vim.lsp.buf.rename() | callback |
| global | n | grr | .config/nvim/lua/plugins/telescope.lua | vim.lsp.buf.references() | callback |
| global | n | grt | .config/nvim/lua/plugins/telescope.lua | vim.lsp.buf.type_definition() | callback |
| global | n | grx | Lua | vim.lsp.codelens.run() | callback |
| global | s | <C-.> | .config/nvim/lua/config/keymaps.lua | Code action | callback |
| global | x | <C-.> | .config/nvim/lua/config/keymaps.lua | Code action | callback |
| global | x | gra | Lua | vim.lsp.buf.code_action() | callback |
| go | n |  th | runtime/generated | LSP: [T]oggle Inlay [H]ints | callback |
| go | n | K | Lua | vim.lsp.buf.hover() | callback |
| go | n | gO | .config/nvim/lua/plugins/telescope.lua | Open Document Symbols | callback |
| go | n | gW | .config/nvim/lua/plugins/telescope.lua | Open Workspace Symbols | callback |
| go | n | grD | .config/nvim/lua/plugins/lsp.lua | LSP: [G]oto [D]eclaration | callback |
| go | n | gra | ~/.config/nvim/init.lua | LSP: [G]oto Code [A]ction | callback |
| go | n | grn | .config/nvim/lua/plugins/lsp.lua | LSP: [R]e[n]ame | callback |
| go | n | grt | .config/nvim/lua/plugins/telescope.lua | [G]oto [T]ype Definition | callback |
| go | x | gra | ~/.config/nvim/init.lua | LSP: [G]oto Code [A]ction | callback |
| lua | n |  th | runtime/generated | LSP: [T]oggle Inlay [H]ints | callback |
| lua | n | K | Lua | vim.lsp.buf.hover() | callback |
| lua | n | gO | .config/nvim/lua/plugins/telescope.lua | Open Document Symbols | callback |
| lua | n | gW | .config/nvim/lua/plugins/telescope.lua | Open Workspace Symbols | callback |
| lua | n | grD | .config/nvim/lua/plugins/lsp.lua | LSP: [G]oto [D]eclaration | callback |
| lua | n | gra | Lua | LSP: [G]oto Code [A]ction | callback |
| lua | n | grn | .config/nvim/lua/plugins/lsp.lua | LSP: [R]e[n]ame | callback |
| lua | n | grt | .config/nvim/lua/plugins/telescope.lua | [G]oto [T]ype Definition | callback |
| lua | x | gra | ~/.config/nvim/init.lua | LSP: [G]oto Code [A]ction | callback |
| typescript | n |  th | runtime/generated | LSP: [T]oggle Inlay [H]ints | callback |
| typescript | n | K | Lua | vim.lsp.buf.hover() | callback |
| typescript | n | gO | .config/nvim/lua/plugins/telescope.lua | Open Document Symbols | callback |
| typescript | n | gW | .config/nvim/lua/plugins/telescope.lua | Open Workspace Symbols | callback |
| typescript | n | grD | .config/nvim/lua/plugins/lsp.lua | LSP: [G]oto [D]eclaration | callback |
| typescript | n | gra | ~/.config/nvim/init.lua | LSP: [G]oto Code [A]ction | callback |
| typescript | n | grn | .config/nvim/lua/plugins/lsp.lua | LSP: [R]e[n]ame | callback |
| typescript | n | grt | .config/nvim/lua/plugins/telescope.lua | [G]oto [T]ype Definition | callback |
| typescript | x | gra | ~/.config/nvim/init.lua | LSP: [G]oto Code [A]ction | callback |

## Multicursor

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | n | <C-D> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: find next | callback |
| global | n | <C-Down> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: add cursor down | callback |
| global | n | <C-Left> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: select left | callback |
| global | n | <C-N> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: select all | callback |
| global | n | <C-Right> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: select right | callback |
| global | n | <C-Up> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: add cursor up | callback |
| global | n | <C-W> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: add word | callback |
| global | n | <C-W><C-D> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Show diagnostics under the cursor | <C-W>d |
| global | n | <C-W>d | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Show diagnostics under the cursor | callback |
| global | n | <C-X> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: add cursor | callback |
| global | x | <C-D> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: find next from selection | callback |
| global | x | <C-N> | ~/.local/share/nvim/site/pack/core/opt/visual-multi.nvim/plugin/visual-multi.lua | Visual Multi: select all from selection | callback |

## Navigation

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | c | <Plug>luasnip-delete-check | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Removes current snippet from jumplist | callback |
| global | i | <Down> | .config/nvim/plugin/navigation.lua | Move down or append one blank line | callback |
| global | i | <Plug>luasnip-delete-check | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Removes current snippet from jumplist | callback |
| global | i | <Plug>luasnip-expand-or-jump | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Expand or jump in the current snippet | callback |
| global | i | <Plug>luasnip-jump-next | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Jump to the next node | callback |
| global | i | <Plug>luasnip-jump-prev | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Jump to the previous node | callback |
| global | i | <S-Tab> | .config/nvim/lua/config/keymaps.lua | vim.snippet.jump if active, otherwise <S-Tab> | callback |
| global | i | <Tab> | .config/nvim/lua/config/keymaps.lua | vim.snippet.jump if active, otherwise <Tab> | callback |
| global | i | <Up> | .config/nvim/plugin/navigation.lua | Move up or remove generated blank line | callback |
| global | n |  f | .config/nvim/lua/plugins/formatting.lua | [F]ormat buffer | callback |
| global | n | <C-H> | .config/nvim/lua/config/keymaps.lua | Move focus to the left window | <C-W><C-H> |
| global | n | <C-J> | .config/nvim/lua/config/keymaps.lua | Move focus to the lower window | <C-W><NL> |
| global | n | <C-K> | .config/nvim/lua/config/keymaps.lua | Move focus to the upper window | <C-W><C-K> |
| global | n | <C-L> | .config/nvim/lua/config/keymaps.lua | Move focus to the right window | <C-W><C-L> |
| global | n | <Down> | .config/nvim/plugin/navigation.lua | Move down or append one blank line | callback |
| global | n | <M-Down> | .config/nvim/lua/config/keymaps.lua | Move line down | :m .+1<CR>== |
| global | n | <M-Left> | .config/nvim/lua/config/keymaps.lua | Previous buffer | <Cmd>bprevious<CR> |
| global | n | <M-Right> | .config/nvim/lua/config/keymaps.lua | Next buffer | <Cmd>bnext<CR> |
| global | n | <M-Up> | .config/nvim/lua/config/keymaps.lua | Move line up | :m .-2<CR>== |
| global | n | <Plug>luasnip-delete-check | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Removes current snippet from jumplist | callback |
| global | n | <Up> | .config/nvim/plugin/navigation.lua | Move up or remove generated blank line | callback |
| global | n | g[ | ~/.config/nvim/init.lua | Move to left "around" | callback |
| global | n | g] | ~/.config/nvim/init.lua | Move to right "around" | callback |
| global | o | g[ | ~/.config/nvim/init.lua | Move to left "around" | callback |
| global | o | g] | ~/.config/nvim/init.lua | Move to right "around" | callback |
| global | s |  f | .config/nvim/lua/plugins/formatting.lua | [F]ormat buffer | callback |
| global | s | <Plug>luasnip-expand-or-jump | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Expand or jump in the current snippet | callback |
| global | s | <Plug>luasnip-jump-next | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Jump to the next node | callback |
| global | s | <Plug>luasnip-jump-prev | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Jump to the previous node | callback |
| global | x |  f | .config/nvim/lua/plugins/formatting.lua | [F]ormat buffer | callback |
| global | x | g[ | ~/.config/nvim/init.lua | Move to left "around" | callback |
| global | x | g] | ~/.config/nvim/init.lua | Move to right "around" | callback |
| markdown | n | [[ | /usr/share/nvim/runtime/ftplugin/markdown.lua | Jump to previous section | callback |
| markdown | n | ]] | /usr/share/nvim/runtime/ftplugin/markdown.lua | Jump to next section | callback |
| markdown | n | gO | /usr/share/nvim/runtime/ftplugin/markdown.lua | Show an Outline of the current buffer | callback |

## Neo-tree

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | n | \ | .config/nvim/lua/kickstart/plugins/neo-tree.lua | NeoTree reveal | <Cmd>Neotree reveal<CR> |

## Other plugin and runtime mappings

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | c | <Plug>(TelescopeFuzzyCommandSearch) | ~/.local/share/nvim/site/pack/core/opt/telescope.nvim/plugin/telescope.lua | RHS: <C-\>e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"<CR><CR> | <C-\>e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"<CR><CR> |
| global | c | <Plug>luasnip-expand-repeat | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Repeat last node expansion | callback |
| global | i | <C-U> | Lua | :help i_CTRL-U-default | <C-G>u<C-U> |
| global | i | <C-W> | Lua | :help i_CTRL-W-default | <C-G>u<C-W> |
| global | i | <CR> | ~/.config/nvim/init.lua | autopairs completion confirm | v:lua.require'nvim-autopairs'.completion_confirm() |
| global | i | <Plug>luasnip-expand-repeat | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Repeat last node expansion | callback |
| global | i | <Plug>luasnip-expand-snippet | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Expand the current snippet | callback |
| global | i | <Plug>luasnip-next-choice | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Change to the next choice from the choiceNode | callback |
| global | i | <Plug>luasnip-prev-choice | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Change to the previous choice from the choiceNode | callback |
| global | n |  s. | .config/nvim/lua/plugins/telescope.lua | [S]earch Recent Files ("." for repeat) | callback |
| global | n |  s/ | .config/nvim/lua/plugins/telescope.lua | [S]earch [/] in Open Files | callback |
| global | n |  sc | .config/nvim/lua/plugins/telescope.lua | [S]earch [C]ommands | callback |
| global | n |  sd | .config/nvim/lua/plugins/telescope.lua | [S]earch [D]iagnostics | callback |
| global | n |  sf | .config/nvim/lua/plugins/telescope.lua | [S]earch [F]iles | callback |
| global | n |  sg | .config/nvim/lua/plugins/telescope.lua | [S]earch by [G]rep | callback |
| global | n |  sh | .config/nvim/lua/plugins/telescope.lua | [S]earch [H]elp | callback |
| global | n |  sk | .config/nvim/lua/plugins/telescope.lua | [S]earch [K]eymaps | callback |
| global | n |  sn | .config/nvim/lua/plugins/telescope.lua | [S]earch [N]eovim files | callback |
| global | n |  sr | .config/nvim/lua/plugins/telescope.lua | [S]earch [R]esume | callback |
| global | n |  sw | .config/nvim/lua/plugins/telescope.lua | [S]earch current [W]ord | callback |
| global | n | % | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 70 | RHS: <Plug>(MatchitNormalForward) | <Plug>(MatchitNormalForward) |
| global | n | & | .config/nvim/lua/config/diagnostics.lua | :help &-default | :&&<CR> |
| global | n | <C-_> | .config/nvim/lua/config/keymaps.lua | Toggle comment | gcc |
| global | n | <Esc> | .config/nvim/lua/config/keymaps.lua | RHS: <Cmd>nohlsearch<CR> | <Cmd>nohlsearch<CR> |
| global | n | <M-S-Down> | .config/nvim/lua/config/keymaps.lua | Duplicate line down | yyp |
| global | n | <M-S-Up> | .config/nvim/lua/config/keymaps.lua | Duplicate line up | yyP |
| global | n | <Plug>(MatchitNormalBackward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 51 | RHS: :<C-U>call matchit#Match_wrapper('',0,'n')<CR> | :<C-U>call matchit#Match_wrapper('',0,'n')<CR> |
| global | n | <Plug>(MatchitNormalForward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 50 | RHS: :<C-U>call matchit#Match_wrapper('',1,'n')<CR> | :<C-U>call matchit#Match_wrapper('',1,'n')<CR> |
| global | n | <Plug>(MatchitNormalMultiBackward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 59 | RHS: :<C-U>call matchit#MultiMatch("bW", "n")<CR> | :<C-U>call matchit#MultiMatch("bW", "n")<CR> |
| global | n | <Plug>(MatchitNormalMultiForward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 60 | RHS: :<C-U>call matchit#MultiMatch("W",  "n")<CR> | :<C-U>call matchit#MultiMatch("W",  "n")<CR> |
| global | n | <Plug>(fzf-insert) | /usr/share/vim/vimfiles/plugin/fzf.vim line 1024 | RHS: i | i |
| global | n | <Plug>(fzf-normal) | /usr/share/vim/vimfiles/plugin/fzf.vim line 1025 | RHS: undocumented callback | callback/unknown |
| global | n | <Plug>PlenaryTestFile | ~/.local/share/nvim/site/pack/core/opt/plenary.nvim/plugin/plenary.vim line 9 | RHS: :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))<CR> | :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))<CR> |
| global | n | <Plug>luasnip-expand-repeat | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Repeat last node expansion | callback |
| global | n | Y | Lua | :help Y-default | y$ |
| global | n | [  | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 78 | Add empty line above cursor | callback |
| global | n | [% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 78 | RHS: <Plug>(MatchitNormalMultiBackward) | <Plug>(MatchitNormalMultiBackward) |
| global | n | [<C-L> | Lua | :lpfile | callback |
| global | n | [<C-Q> | Lua | :cpfile | callback |
| global | n | [<C-T> | Lua | :ptprevious | callback |
| global | n | [A | Lua | :rewind | callback |
| global | n | [B | Lua | :brewind | callback |
| global | n | [L | Lua | :lrewind | callback |
| global | n | [Q | Lua | :crewind | callback |
| global | n | [T | Lua | :trewind | callback |
| global | n | [a | Lua | :previous | callback |
| global | n | [b | Lua | :bprevious | callback |
| global | n | [l | Lua | :lprevious | callback |
| global | n | [q | .config/nvim/lua/plugins/ui.lua | :cprevious | callback |
| global | n | [t | Lua | :tprevious | callback |
| global | n | ]  | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 79 | Add empty line below cursor | callback |
| global | n | ]% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 79 | RHS: <Plug>(MatchitNormalMultiForward) | <Plug>(MatchitNormalMultiForward) |
| global | n | ]<C-L> | Lua | :lnfile | callback |
| global | n | ]<C-Q> | Lua | :cnfile | callback |
| global | n | ]<C-T> | Lua | :ptnext | callback |
| global | n | ]A | Lua | :last | callback |
| global | n | ]B | Lua | :blast | callback |
| global | n | ]L | Lua | :llast | callback |
| global | n | ]Q | Lua | :clast | callback |
| global | n | ]T | Lua | :tlast | callback |
| global | n | ]a | Lua | :next | callback |
| global | n | ]b | Lua | :bnext | callback |
| global | n | ]l | .config/nvim/lua/plugins/ui.lua | :lnext | callback |
| global | n | ]q | .config/nvim/lua/plugins/ui.lua | :cnext | callback |
| global | n | ]t | .config/nvim/lua/plugins/ui.lua | :tnext | callback |
| global | n | g% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 71 | RHS: <Plug>(MatchitNormalBackward) | <Plug>(MatchitNormalBackward) |
| global | n | gc | .config/nvim/lua/config/keymaps.lua | Toggle comment | callback |
| global | n | gcc | .config/nvim/lua/config/keymaps.lua | Toggle comment line | callback |
| global | n | gx | Lua | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | callback |
| global | n | s | ~/.config/nvim/init.lua | RHS: undocumented callback | callback/unknown |
| global | n | sa | ~/.config/nvim/init.lua | Add surrounding | callback |
| global | n | sh | ~/.config/nvim/init.lua | Highlight surrounding | callback |
| global | n | shl | ~/.config/nvim/init.lua | Highlight previous surrounding | callback |
| global | n | shn | ~/.config/nvim/init.lua | Highlight next surrounding | callback |
| global | n | sr | ~/.config/nvim/init.lua | Replace surrounding | callback |
| global | n | srl | ~/.config/nvim/init.lua | Replace previous surrounding | callback |
| global | n | srn | ~/.config/nvim/init.lua | Replace next surrounding | callback |
| global | o | % | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 74 | RHS: <Plug>(MatchitOperationForward) | <Plug>(MatchitOperationForward) |
| global | o | <Plug>(MatchitOperationBackward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 56 | RHS: :<C-U>call matchit#Match_wrapper('',0,'o')<CR> | :<C-U>call matchit#Match_wrapper('',0,'o')<CR> |
| global | o | <Plug>(MatchitOperationForward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 55 | RHS: :<C-U>call matchit#Match_wrapper('',1,'o')<CR> | :<C-U>call matchit#Match_wrapper('',1,'o')<CR> |
| global | o | <Plug>(MatchitOperationMultiBackward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 63 | RHS: :<C-U>call matchit#MultiMatch("bW", "o")<CR> | :<C-U>call matchit#MultiMatch("bW", "o")<CR> |
| global | o | <Plug>(MatchitOperationMultiForward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 64 | RHS: :<C-U>call matchit#MultiMatch("W",  "o")<CR> | :<C-U>call matchit#MultiMatch("W",  "o")<CR> |
| global | o | <Plug>luasnip-expand-repeat | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Repeat last node expansion | callback |
| global | o | [% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 82 | RHS: <Plug>(MatchitOperationMultiBackward) | <Plug>(MatchitOperationMultiBackward) |
| global | o | ]% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 83 | RHS: <Plug>(MatchitOperationMultiForward) | <Plug>(MatchitOperationMultiForward) |
| global | o | a | ~/.config/nvim/init.lua | Around textobject | callback |
| global | o | aa | .config/nvim/lua/plugins/ui.lua | Around next textobject | callback |
| global | o | al | ~/.config/nvim/init.lua | Around last textobject | callback |
| global | o | g% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 75 | RHS: <Plug>(MatchitOperationBackward) | <Plug>(MatchitOperationBackward) |
| global | o | gc | .config/nvim/lua/config/keymaps.lua | Comment textobject | callback |
| global | o | i | .config/nvim/lua/plugins/ui.lua | Inside textobject | callback |
| global | o | ii | .config/nvim/lua/plugins/ui.lua | Inside next textobject | callback |
| global | o | il | ~/.config/nvim/init.lua | Inside last textobject | callback |
| global | o | s | ~/.config/nvim/init.lua | RHS: undocumented callback | callback/unknown |
| global | s |  sw | .config/nvim/lua/plugins/telescope.lua | [S]earch current [W]ord | callback |
| global | s | <Plug>luasnip-expand-repeat | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Repeat last node expansion | callback |
| global | s | <Plug>luasnip-expand-snippet | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Expand the current snippet | callback |
| global | s | <Plug>luasnip-next-choice | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Change to the next choice from the choiceNode | callback |
| global | s | <Plug>luasnip-prev-choice | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Change to the previous choice from the choiceNode | callback |
| global | t | <Esc><Esc> | .config/nvim/lua/config/keymaps.lua | Exit terminal mode | <C-\><C-N> |
| global | t | <Plug>(fzf-insert) | /usr/share/vim/vimfiles/plugin/fzf.vim line 1027 | RHS: <C-\><C-N>i | <C-\><C-N>i |
| global | t | <Plug>(fzf-normal) | /usr/share/vim/vimfiles/plugin/fzf.vim line 1028 | RHS: <C-\><C-N> | <C-\><C-N> |
| global | x |  sw | .config/nvim/lua/plugins/telescope.lua | [S]earch current [W]ord | callback |
| global | x | # | Lua | :help v_#-default | callback |
| global | x | % | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 72 | RHS: <Plug>(MatchitVisualForward) | <Plug>(MatchitVisualForward) |
| global | x | * | Lua | :help v_star-default | callback |
| global | x | <Plug>(MatchitVisualBackward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 54 | RHS: :<C-U>call matchit#Match_wrapper('',0,'v')<CR>m'gv\`\` | :<C-U>call matchit#Match_wrapper('',0,'v')<CR>m'gv\`\` |
| global | x | <Plug>(MatchitVisualForward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 52 | RHS: :<C-U>call matchit#Match_wrapper('',1,'v')<CR>:if col("''") != col("$") \| exe ":normal! m'" \| endif<CR>gv\`\` | :<C-U>call matchit#Match_wrapper('',1,'v')<CR>:if col("''") != col("$") \| exe ":normal! m'" \| endif<CR>gv\`\` |
| global | x | <Plug>(MatchitVisualMultiBackward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 61 | RHS: :<C-U>call matchit#MultiMatch("bW", "n")<CR>m'gv\`\` | :<C-U>call matchit#MultiMatch("bW", "n")<CR>m'gv\`\` |
| global | x | <Plug>(MatchitVisualMultiForward) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 62 | RHS: :<C-U>call matchit#MultiMatch("W",  "n")<CR>m'gv\`\` | :<C-U>call matchit#MultiMatch("W",  "n")<CR>m'gv\`\` |
| global | x | <Plug>(MatchitVisualTextObject) | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 67 | RHS: <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward) | <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward) |
| global | x | <Plug>luasnip-expand-repeat | ~/.local/share/nvim/site/pack/core/opt/LuaSnip/plugin/luasnip.lua | LuaSnip: Repeat last node expansion | callback |
| global | x | @ | Lua | :help v_@-default | mode() ==# 'V' ? ':normal! @'.getcharstr().'<CR>' : '@' |
| global | x | Q | Lua | :help v_Q-default | mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q' |
| global | x | [% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 80 | RHS: <Plug>(MatchitVisualMultiBackward) | <Plug>(MatchitVisualMultiBackward) |
| global | x | ]% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 81 | RHS: <Plug>(MatchitVisualMultiForward) | <Plug>(MatchitVisualMultiForward) |
| global | x | a | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 86 | Around textobject | callback |
| global | x | a% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 86 | RHS: <Plug>(MatchitVisualTextObject) | <Plug>(MatchitVisualTextObject) |
| global | x | aa | .config/nvim/lua/plugins/ui.lua | Around next textobject | callback |
| global | x | al | ~/.config/nvim/init.lua | Around last textobject | callback |
| global | x | g% | /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim line 73 | RHS: <Plug>(MatchitVisualBackward) | <Plug>(MatchitVisualBackward) |
| global | x | gc | .config/nvim/lua/config/keymaps.lua | Toggle comment | callback |
| global | x | gx | Lua | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) | callback |
| global | x | i | .config/nvim/lua/plugins/ui.lua | Inside textobject | callback |
| global | x | ii | .config/nvim/lua/plugins/ui.lua | Inside next textobject | callback |
| global | x | il | ~/.config/nvim/init.lua | Inside last textobject | callback |
| global | x | s | ~/.config/nvim/init.lua | RHS: undocumented callback | callback/unknown |
| go | i | " | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | ' | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | ( | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | ) | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | [ | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | ] | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | \` | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | { | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | i | } | ~/.config/nvim/init.lua | autopairs map key | callback |
| go | n | [[ | /usr/share/nvim/runtime/ftplugin/go.vim line 57 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> |
| go | n | [] | /usr/share/nvim/runtime/ftplugin/go.vim line 58 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> |
| go | n | ][ | /usr/share/nvim/runtime/ftplugin/go.vim line 56 | RHS: <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> |
| go | n | ]] | /usr/share/nvim/runtime/ftplugin/go.vim line 55 | RHS: <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> |
| go | n | grd | .config/nvim/lua/plugins/telescope.lua | [G]oto [D]efinition | callback |
| go | n | gri | .config/nvim/lua/plugins/telescope.lua | [G]oto [I]mplementation | callback |
| go | n | grr | .config/nvim/lua/plugins/telescope.lua | [G]oto [R]eferences | callback |
| go | o | [[ | /usr/share/nvim/runtime/ftplugin/go.vim line 57 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> |
| go | o | [] | /usr/share/nvim/runtime/ftplugin/go.vim line 58 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> |
| go | o | ][ | /usr/share/nvim/runtime/ftplugin/go.vim line 56 | RHS: <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> |
| go | o | ]] | /usr/share/nvim/runtime/ftplugin/go.vim line 55 | RHS: <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> |
| go | s | [[ | /usr/share/nvim/runtime/ftplugin/go.vim line 57 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> |
| go | s | [] | /usr/share/nvim/runtime/ftplugin/go.vim line 58 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> |
| go | s | ][ | /usr/share/nvim/runtime/ftplugin/go.vim line 56 | RHS: <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> |
| go | s | ]] | /usr/share/nvim/runtime/ftplugin/go.vim line 55 | RHS: <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> |
| go | x | [[ | /usr/share/nvim/runtime/ftplugin/go.vim line 57 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_start', v:count1)<CR> |
| go | x | [] | /usr/share/nvim/runtime/ftplugin/go.vim line 58 | RHS: <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('prev_end', v:count1)<CR> |
| go | x | ][ | /usr/share/nvim/runtime/ftplugin/go.vim line 56 | RHS: <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_end', v:count1)<CR> |
| go | x | ]] | /usr/share/nvim/runtime/ftplugin/go.vim line 55 | RHS: <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> | <Cmd>call <SNR>63_GoFindSection('next_start', v:count1)<CR> |
| json | i | " | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | ' | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | ( | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | ) | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | [ | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | ] | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | \` | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | { | ~/.config/nvim/init.lua | autopairs map key | callback |
| json | i | } | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | " | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | ' | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | ( | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | ) | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | [ | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | ] | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | \` | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | { | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | i | } | ~/.config/nvim/init.lua | autopairs map key | callback |
| lua | n |   | Lua | which-key-trigger | callback |
| lua | n | " | Lua | which-key-trigger registers | callback |
| lua | n | ' | Lua | which-key-trigger marks | callback |
| lua | n | <Plug> | Lua | which-key-trigger | callback |
| lua | n | [ | Lua | which-key-trigger | callback |
| lua | n | ] | Lua | which-key-trigger | callback |
| lua | n | \` | Lua | which-key-trigger marks | callback |
| lua | n | g | Lua | which-key-trigger | callback |
| lua | n | g' | Lua | which-key-trigger marks | callback |
| lua | n | g\` | .config/nvim/lua/plugins/lsp.lua | which-key-trigger marks | callback |
| lua | n | grd | .config/nvim/lua/plugins/telescope.lua | [G]oto [D]efinition | callback |
| lua | n | gri | .config/nvim/lua/plugins/telescope.lua | [G]oto [I]mplementation | callback |
| lua | n | grr | .config/nvim/lua/plugins/telescope.lua | [G]oto [R]eferences | callback |
| lua | n | z | Lua | which-key-trigger | callback |
| lua | n | z= | Lua | which-key-trigger spelling | callback |
| markdown | i | " | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | ' | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | ( | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | ) | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | - | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | > | ~/.config/nvim/after/plugin/react-tags.lua | RHS: undocumented callback | callback/unknown |
| markdown | i | [ | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | ] | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | \` | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | { | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | i | } | ~/.config/nvim/init.lua | autopairs map key | callback |
| markdown | x | [[ | /usr/share/nvim/runtime/ftplugin/markdown.vim line 33 | RHS: :<C-U>exe "normal! gv"\|call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR> | :<C-U>exe "normal! gv"\|call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR> |
| markdown | x | ]] | /usr/share/nvim/runtime/ftplugin/markdown.vim line 34 | RHS: :<C-U>exe "normal! gv"\|call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR> | :<C-U>exe "normal! gv"\|call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR> |
| typescript | i | " | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | ' | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | ( | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | ) | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | > | ~/.config/nvim/after/plugin/react-tags.lua | RHS: undocumented callback | callback/unknown |
| typescript | i | [ | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | ] | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | \` | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | { | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | i | } | ~/.config/nvim/init.lua | autopairs map key | callback |
| typescript | n | grd | .config/nvim/lua/plugins/telescope.lua | [G]oto [D]efinition | callback |
| typescript | n | gri | .config/nvim/lua/plugins/telescope.lua | [G]oto [I]mplementation | callback |
| typescript | n | grr | .config/nvim/lua/plugins/telescope.lua | [G]oto [R]eferences | callback |

## Search

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | n |    | .config/nvim/lua/plugins/telescope.lua | [ ] Find existing buffers | callback |
| global | n |  / | .config/nvim/lua/plugins/telescope.lua | [/] Fuzzily search in current buffer | callback |
| global | n |  ss | .config/nvim/lua/plugins/telescope.lua | [S]earch [S]elect Telescope | callback |
| global | n | <C-P> | .config/nvim/lua/config/keymaps.lua | Quick open file | callback |
| global | n | <C-S-F> | .config/nvim/lua/config/keymaps.lua | Search project | callback |
| global | n | <C-S-P> | .config/nvim/lua/config/keymaps.lua | Command palette | callback |
| global | n | sF | .config/nvim/lua/plugins/lsp.lua | Find left surrounding | callback |
| global | n | sFl | ~/.config/nvim/init.lua | Find previous left surrounding | callback |
| global | n | sFn | ~/.config/nvim/init.lua | Find next left surrounding | callback |
| global | n | sf | .config/nvim/lua/plugins/telescope.lua | Find right surrounding | callback |
| global | n | sfl | ~/.config/nvim/init.lua | Find previous right surrounding | callback |
| global | n | sfn | ~/.config/nvim/init.lua | Find next right surrounding | callback |
| global | o | sF | .config/nvim/lua/plugins/lsp.lua | Find left surrounding | callback |
| global | o | sFl | ~/.config/nvim/init.lua | Find previous left surrounding | callback |
| global | o | sFn | ~/.config/nvim/init.lua | Find next left surrounding | callback |
| global | o | sf | .config/nvim/lua/plugins/telescope.lua | Find right surrounding | callback |
| global | o | sfl | ~/.config/nvim/init.lua | Find previous right surrounding | callback |
| global | o | sfn | ~/.config/nvim/init.lua | Find next right surrounding | callback |
| global | x | sF | .config/nvim/lua/plugins/lsp.lua | Find left surrounding | callback |
| global | x | sFl | ~/.config/nvim/init.lua | Find previous left surrounding | callback |
| global | x | sFn | ~/.config/nvim/init.lua | Find next left surrounding | callback |
| global | x | sf | .config/nvim/lua/plugins/telescope.lua | Find right surrounding | callback |
| global | x | sfl | ~/.config/nvim/init.lua | Find previous right surrounding | callback |
| global | x | sfn | ~/.config/nvim/init.lua | Find next right surrounding | callback |

## Selection and clipboard

| Scope | Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|---|
| global | i | <C-A> | .config/nvim/lua/config/keymaps.lua | Select all | <Esc>ggVG |
| global | i | <C-S-C> | .config/nvim/plugin/navigation.lua | Copy current line | <C-O>"+yy |
| global | i | <C-S-Down> | .config/nvim/plugin/navigation.lua | Select whole lines downward | <C-O>Vj<C-G> |
| global | i | <C-S-Left> | .config/nvim/plugin/navigation.lua | Select previous word | <C-O>vb<C-G> |
| global | i | <C-S-Right> | .config/nvim/plugin/navigation.lua | Select next word | <C-O>ve<C-G> |
| global | i | <C-S-Up> | .config/nvim/plugin/navigation.lua | Select whole lines upward | <C-O>Vk<C-G> |
| global | i | <C-S-X> | .config/nvim/plugin/navigation.lua | Cut current line | <C-O>"+dd |
| global | n | <C-A> | .config/nvim/lua/config/keymaps.lua | Select all | ggVG |
| global | n | <C-S-C> | .config/nvim/plugin/navigation.lua | Copy current line | "+yy |
| global | n | <C-S-X> | .config/nvim/plugin/navigation.lua | Cut current line | "+dd |
| global | o | an | ~/.config/nvim/init.lua | Select parent (outer) node | callback |
| global | o | in | ~/.config/nvim/init.lua | Select child (inner) node | callback |
| global | s | <C-S-Down> | .config/nvim/plugin/navigation.lua | Select whole lines downward | <C-O>j |
| global | s | <C-S-Left> | .config/nvim/plugin/navigation.lua | Select previous word | <C-O>b |
| global | s | <C-S-Right> | .config/nvim/plugin/navigation.lua | Select next word | <C-O>e |
| global | s | <C-S-Up> | .config/nvim/plugin/navigation.lua | Select whole lines upward | <C-O>k |
| global | s | <C-_> | .config/nvim/lua/config/keymaps.lua | Toggle comment selection | gc |
| global | s | <M-Down> | .config/nvim/lua/config/keymaps.lua | Move selection down | :m '>+1<CR>gv=gv |
| global | s | <M-Up> | .config/nvim/lua/config/keymaps.lua | Move selection up | :m '<lt>-2<CR>gv=gv |
| global | x | <C-A> | .config/nvim/lua/config/keymaps.lua | Select all | <Esc>ggVG |
| global | x | <C-S-C> | .config/nvim/plugin/navigation.lua | Copy selection | "+y |
| global | x | <C-S-X> | .config/nvim/plugin/navigation.lua | Cut selection | "+d |
| global | x | <C-_> | .config/nvim/lua/config/keymaps.lua | Toggle comment selection | gc |
| global | x | <M-Down> | .config/nvim/lua/config/keymaps.lua | Move selection down | :m '>+1<CR>gv=gv |
| global | x | <M-Up> | .config/nvim/lua/config/keymaps.lua | Move selection up | :m '<lt>-2<CR>gv=gv |
| global | x | [N | Lua | Select previous sibling node | callback |
| global | x | [n | .config/nvim/lua/plugins/lsp.lua | Select previous node | callback |
| global | x | ]N | Lua | Select next sibling node | callback |
| global | x | ]n | .config/nvim/lua/plugins/ui.lua | Select next node | callback |
| global | x | an | ~/.config/nvim/init.lua | Select parent (outer) node | callback |
| global | x | in | ~/.config/nvim/init.lua | Select child (inner) node | callback |
| global | x | sa | ~/.config/nvim/init.lua | Add surrounding to selection | :<C-U>lua MiniSurround.add("visual")<CR> |

## Capture limits

This is an effective runtime snapshot, not a claim that every action was physically pressed. Terminal encoding and event-driven maps require separate tests. Built-in runtime maps are retained where they appear in the snapshot to make precedence visible.
