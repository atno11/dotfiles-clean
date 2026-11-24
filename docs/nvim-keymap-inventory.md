# Neovim effective keymap inventory

Captured from the effective `~/.config/nvim` on Neovim 0.12.6. The first phase recorded 618 map entries across global, filetype, and active plugin states; Phase 2 adds 62 active Telescope prompt entries, for 680 state-specific entries in total. The same mapping may appear in several contexts. `nvim_get_keymap` and `nvim_buf_get_keymap` supplied the effective maps; `:verbose map` supplied the runtime source where available. A callback RHS appears as `callback`; its description states intended behavior. `Lua` and `runtime/generated` sources are unresolved runtime provenance. Other plugin UI states can add buffer maps.

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

## Dynamic buffer snapshots

These mappings were captured after opening Neo-tree, attaching `lua_ls` to a Lua buffer, attaching Gitsigns to a tracked file in a temporary Git repository, and entering a three-selection visual-multi session. They supplement the earlier global and filetype snapshots. The source column identifies the setup or plugin responsible for the buffer map; an `unknown` action means a Lua callback with no description.

### Neo-tree open buffer

| Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|
| n |   | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | toggle_node | callback |
| n | # | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | fuzzy_sorter | callback |
| n | . | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | set_root | callback |
| n | / | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | fuzzy_finder | callback |
| n | <2-LeftMouse> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | open | callback |
| n | <BS> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | navigate_up | callback |
| n | <C-;> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | clear_selection | callback |
| n | <C-B> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | scroll_preview | callback |
| n | <C-F> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | scroll_preview | callback |
| n | <C-R> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | clear_clipboard | callback |
| n | <C-S-I> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | invert_selection | callback |
| n | <C-S> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | quick_jump | callback |
| n | <C-X> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | clear_filter | callback |
| n | <CR> | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | open | callback |
| n | <Down> | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | undocumented callback | callback |
| n | <Esc> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | cancel | callback |
| n | <Left> | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | close_node | callback |
| n | <Right> | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | undocumented callback | callback |
| n | <Tab> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | select | callback |
| n | <Up> | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | undocumented callback | callback |
| n | <lt> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | prev_source | callback |
| n | > | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | next_source | callback |
| n | ? | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | show_help | callback |
| n | A | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | add_directory | callback |
| n | C | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | close_node | callback |
| n | D | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | fuzzy_finder_directory | callback |
| n | H | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | toggle_hidden | callback |
| n | P | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | toggle_preview | callback |
| n | R | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | refresh | callback |
| n | S | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | open_split | callback |
| n | T | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | trash | callback |
| n | U | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | restore_from_trash | callback |
| n | [g | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | prev_git_modified | callback |
| n | \ | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | close_window | callback |
| n | ]g | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | next_git_modified | callback |
| n | a | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | add | callback |
| n | b | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | rename_basename | callback |
| n | c | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | copy | callback |
| n | d | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | add_directory | callback |
| n | e | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | toggle_auto_expand_width | callback |
| n | f | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | add | callback |
| n | i | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | show_file_details | callback |
| n | j | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | undocumented callback | callback |
| n | k | ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | undocumented callback | callback |
| n | l | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | focus_preview | callback |
| n | m | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | move | callback |
| n | o | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | show_help | callback |
| n | oc | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_created | callback |
| n | od | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_diagnostics | callback |
| n | og | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_git_status | callback |
| n | om | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_modified | callback |
| n | on | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_name | callback |
| n | os | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_size | callback |
| n | ot | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | order_by_type | callback |
| n | p | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | paste_from_clipboard | callback |
| n | q | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | close_window | callback |
| n | r | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | rename | callback |
| n | s | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | open_vsplit | callback |
| n | t | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | open_tabnew | callback |
| n | u | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | undo | callback |
| n | w | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | open_with_window_picker | callback |
| n | x | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | cut_to_clipboard | callback |
| n | y | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | copy_to_clipboard | callback |
| n | z | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | close_all_nodes | callback |
| s | <C-S-I> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | invert_selection | callback |
| s | <Tab> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | select | callback |
| s | T | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | trash | callback |
| s | U | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | restore_from_trash | callback |
| s | x | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | cut_to_clipboard | callback |
| s | y | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | copy_to_clipboard | callback |
| x | <C-S-I> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | invert_selection | callback |
| x | <Tab> | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | select | callback |
| x | T | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | trash | callback |
| x | U | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | restore_from_trash | callback |
| x | x | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | cut_to_clipboard | callback |
| x | y | neo-tree.nvim buffer maps; custom overrides in ~/.config/nvim/lua/kickstart/plugins/neo-tree.lua | copy_to_clipboard | callback |

### Attached Lua LSP buffer

| Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|
| i | " | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | ' | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | ( | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | ) | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | <BS> | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs delete | callback |
| i | [ | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | ] | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | \` | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | { | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| i | } | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | autopairs map key | callback |
| n |   | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger | callback |
| n |  hD | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [D]iff against last commit | callback |
| n |  hQ | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git hunk [Q]uickfix list (all files in repo) | callback |
| n |  hR | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [R]eset buffer | callback |
| n |  hS | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [S]tage buffer | callback |
| n |  hb | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [b]lame line | callback |
| n |  hd | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [d]iff against index | callback |
| n |  hi | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git preview hunk [i]nline | callback |
| n |  hp | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [p]review hunk | callback |
| n |  hq | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git hunk [q]uickfix list (all changes in this file) | callback |
| n |  hr | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [r]eset hunk | callback |
| n |  hs | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [s]tage hunk | callback |
| n |  tb | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | [T]oggle git show [b]lame line | callback |
| n |  th | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | LSP: [T]oggle Inlay [H]ints | callback |
| n |  tw | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | [T]oggle git intra-line [w]ord diff | callback |
| n | " | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger registers | callback |
| n | ' | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger marks | callback |
| n | <Plug> | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger | callback |
| n | K | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | vim.lsp.buf.hover() | callback |
| n | [ | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger | callback |
| n | [c | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | Jump to previous git [c]hange | callback |
| n | ] | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger | callback |
| n | ]c | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | Jump to next git [c]hange | callback |
| n | \` | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger marks | callback |
| n | g | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger | callback |
| n | g' | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger marks | callback |
| n | gO | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | Open Document Symbols | callback |
| n | gW | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | Open Workspace Symbols | callback |
| n | g\` | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger marks | callback |
| n | grD | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | LSP: [G]oto [D]eclaration | callback |
| n | gra | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | LSP: [G]oto Code [A]ction | callback |
| n | grd | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | [G]oto [D]efinition | callback |
| n | gri | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | [G]oto [I]mplementation | callback |
| n | grn | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | LSP: [R]e[n]ame | callback |
| n | grr | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | [G]oto [R]eferences | callback |
| n | grt | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | [G]oto [T]ype Definition | callback |
| n | z | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger | callback |
| n | z= | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | which-key-trigger spelling | callback |
| o | ih | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | text object [i]nside [h]unk | callback |
| s |  hr | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [r]eset hunk | callback |
| s |  hs | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [s]tage hunk | callback |
| x |  hr | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [r]eset hunk | callback |
| x |  hs | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | git [s]tage hunk | callback |
| x | gra | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | LSP: [G]oto Code [A]ction | callback |
| x | ih | LSP/Telescope attachment in ~/.config/nvim/lua/plugins/lsp.lua and telescope.lua; other plugin buffer maps | text object [i]nside [h]unk | callback |

### Attached Gitsigns buffer

| Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|
| n |   | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger | callback |
| n |  hD | ~/.config/nvim/lua/plugins/ui.lua | git [D]iff against last commit | callback |
| n |  hQ | ~/.config/nvim/lua/plugins/ui.lua | git hunk [Q]uickfix list (all files in repo) | callback |
| n |  hR | ~/.config/nvim/lua/plugins/ui.lua | git [R]eset buffer | callback |
| n |  hS | ~/.config/nvim/lua/plugins/ui.lua | git [S]tage buffer | callback |
| n |  hb | ~/.config/nvim/lua/plugins/ui.lua | git [b]lame line | callback |
| n |  hd | ~/.config/nvim/lua/plugins/ui.lua | git [d]iff against index | callback |
| n |  hi | ~/.config/nvim/lua/plugins/ui.lua | git preview hunk [i]nline | callback |
| n |  hp | ~/.config/nvim/lua/plugins/ui.lua | git [p]review hunk | callback |
| n |  hq | ~/.config/nvim/lua/plugins/ui.lua | git hunk [q]uickfix list (all changes in this file) | callback |
| n |  hr | ~/.config/nvim/lua/plugins/ui.lua | git [r]eset hunk | callback |
| n |  hs | ~/.config/nvim/lua/plugins/ui.lua | git [s]tage hunk | callback |
| n |  tb | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | [T]oggle git show [b]lame line | callback |
| n |  tw | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | [T]oggle git intra-line [w]ord diff | callback |
| n | " | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger registers | callback |
| n | ' | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger marks | callback |
| n | <Plug> | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger | callback |
| n | [ | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger | callback |
| n | [c | ~/.config/nvim/lua/plugins/ui.lua | Jump to previous git [c]hange | callback |
| n | ] | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger | callback |
| n | ]c | ~/.config/nvim/lua/plugins/ui.lua | Jump to next git [c]hange | callback |
| n | \` | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger marks | callback |
| n | g | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger | callback |
| n | g' | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger marks | callback |
| n | g\` | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger marks | callback |
| n | z | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger | callback |
| n | z= | Gitsigns on_attach in ~/.config/nvim/lua/plugins/ui.lua; which-key triggers | which-key-trigger spelling | callback |
| o | ih | ~/.config/nvim/lua/plugins/ui.lua | text object [i]nside [h]unk | callback |
| s |  hr | ~/.config/nvim/lua/plugins/ui.lua | git [r]eset hunk | callback |
| s |  hs | ~/.config/nvim/lua/plugins/ui.lua | git [s]tage hunk | callback |
| x |  hr | ~/.config/nvim/lua/plugins/ui.lua | git [r]eset hunk | callback |
| x |  hs | ~/.config/nvim/lua/plugins/ui.lua | git [s]tage hunk | callback |
| x | ih | ~/.config/nvim/lua/plugins/ui.lua | text object [i]nside [h]unk | callback |

### Active visual-multi session

| Mode | Key | Source | Intended behavior | Effective action |
|---|---|---|---|---|
| i | <C-V> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: paste at cursors | callback |
| n |   | visual-multi.nvim session maps; which-key triggers | which-key-trigger | callback |
| n | " | visual-multi.nvim session maps; which-key triggers | which-key-trigger registers | callback |
| n | $ | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move $ | callback |
| n | ' | visual-multi.nvim session maps; which-key triggers | which-key-trigger marks | callback |
| n | + | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: increase number | callback |
| n | 0 | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move 0 | callback |
| n | <C-D> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: find next | callback |
| n | <C-Down> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: add cursor down | callback |
| n | <C-Left> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: select left | callback |
| n | <C-N> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: select all | callback |
| n | <C-R> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: redo | callback |
| n | <C-Right> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: select right | callback |
| n | <C-Up> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: add cursor up | callback |
| n | <C-W> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: add word | callback |
| n | <C-X> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: add cursor | callback |
| n | <Esc> | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: leave mode or clear | callback |
| n | <Plug> | visual-multi.nvim session maps; which-key triggers | which-key-trigger | callback |
| n | A | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: append at line end | callback |
| n | D | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: delete to end of line | callback |
| n | I | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: insert at first nonblank | callback |
| n | N | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: find previous | callback |
| n | O | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: open line above | callback |
| n | U | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: uppercase selections | callback |
| n | V | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: shrink selection | callback |
| n | [ | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: previous cursor | callback |
| n | ] | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: next cursor | callback |
| n | ^ | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move ^ | callback |
| n | _ | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: decrease number | callback |
| n | \` | visual-multi.nvim session maps; which-key triggers | which-key-trigger marks | callback |
| n | a | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: append | callback |
| n | b | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move b | callback |
| n | c | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: change | callback |
| n | d | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: delete | callback |
| n | e | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move e | callback |
| n | g | visual-multi.nvim session maps; which-key triggers | which-key-trigger | callback |
| n | g' | visual-multi.nvim session maps; which-key triggers | which-key-trigger marks | callback |
| n | g\` | visual-multi.nvim session maps; which-key triggers | which-key-trigger marks | callback |
| n | h | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move h | callback |
| n | i | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: insert | callback |
| n | j | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move j | callback |
| n | k | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move k | callback |
| n | l | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move l | callback |
| n | o | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: open line below | callback |
| n | p | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: paste | callback |
| n | q | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: remove current | callback |
| n | u | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: undo or lowercase selections | callback |
| n | v | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: expand selection | callback |
| n | w | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: move w | callback |
| n | x | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: delete character | callback |
| n | y | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: yank | callback |
| n | z | visual-multi.nvim session maps; which-key triggers | which-key-trigger | callback |
| n | z= | visual-multi.nvim session maps; which-key triggers | which-key-trigger spelling | callback |
| n | ~ | visual-multi.nvim/lua/visual-multi/mappings.lua | Visual Multi: toggle character case | callback |

### Active Telescope prompt

The `find_files` picker was open in a PTY. These 62 buffer-local mappings are plugin-defined and transient. Input `sample` filtered two temporary files, and `<CR>` opened `/tmp/km-telescope-fixture/sample.txt`.

| Mode | Key | Class and source | Intended behavior | Effective action |
|---|---|---|---|---|
| i | <2-LeftMouse> | plugin default: telescope.nvim | telescope\|double_mouse_click | callback |
| i | <C-/> | plugin default: telescope.nvim | telescope\|which_key | callback |
| i | <C-C> | plugin default: telescope.nvim | telescope\|close | callback |
| i | <C-D> | plugin default: telescope.nvim | telescope\|preview_scrolling_down | callback |
| i | <C-F> | plugin default: telescope.nvim | telescope\|preview_scrolling_left | callback |
| i | <C-J> | plugin default: telescope.nvim | telescope\|nop | callback |
| i | <C-K> | plugin default: telescope.nvim | telescope\|preview_scrolling_right | callback |
| i | <C-L> | plugin default: telescope.nvim | telescope\|complete_tag | callback |
| i | <C-N> | plugin default: telescope.nvim | telescope\|move_selection_next | callback |
| i | <C-P> | plugin default: telescope.nvim | telescope\|move_selection_previous | callback |
| i | <C-Q> | plugin default: telescope.nvim | telescope\|send_to_qflist + open_qflist | callback |
| i | <C-R> | plugin default: telescope.nvim | which-key-trigger registers | callback |
| i | <C-R><C-A> | plugin default: telescope.nvim | telescope\|insert_original_cWORD | callback |
| i | <C-R><C-F> | plugin default: telescope.nvim | telescope\|insert_original_cfile | callback |
| i | <C-R><C-L> | plugin default: telescope.nvim | telescope\|insert_original_cline | callback |
| i | <C-R><C-W> | plugin default: telescope.nvim | telescope\|insert_original_cword | callback |
| i | <C-T> | plugin default: telescope.nvim | telescope\|select_tab | callback |
| i | <C-U> | plugin default: telescope.nvim | telescope\|preview_scrolling_up | callback |
| i | <C-V> | plugin default: telescope.nvim | telescope\|select_vertical | callback |
| i | <C-W> | plugin default: telescope.nvim | undocumented callback | <C-S-W> |
| i | <C-X> | plugin default: telescope.nvim | telescope\|select_horizontal | callback |
| i | <C-_> | plugin default: telescope.nvim | telescope\|which_key | callback |
| i | <CR> | plugin default: telescope.nvim | telescope\|select_default | callback |
| i | <Down> | plugin default: telescope.nvim | telescope\|move_selection_next | callback |
| i | <LeftMouse> | plugin default: telescope.nvim | telescope\|mouse_click | callback |
| i | <M-f> | plugin default: telescope.nvim | telescope\|results_scrolling_left | callback |
| i | <M-k> | plugin default: telescope.nvim | telescope\|results_scrolling_right | callback |
| i | <M-q> | plugin default: telescope.nvim | telescope\|send_selected_to_qflist + open_qflist | callback |
| i | <PageDown> | plugin default: telescope.nvim | telescope\|results_scrolling_down | callback |
| i | <PageUp> | plugin default: telescope.nvim | telescope\|results_scrolling_up | callback |
| i | <S-Tab> | plugin default: telescope.nvim | telescope\|toggle_selection + move_selection_better | callback |
| i | <Tab> | plugin default: telescope.nvim | telescope\|toggle_selection + move_selection_worse | callback |
| i | <Up> | plugin default: telescope.nvim | telescope\|move_selection_previous | callback |
| n | <2-LeftMouse> | plugin default: telescope.nvim | telescope\|double_mouse_click | callback |
| n | <C-D> | plugin default: telescope.nvim | telescope\|preview_scrolling_down | callback |
| n | <C-F> | plugin default: telescope.nvim | telescope\|preview_scrolling_left | callback |
| n | <C-K> | plugin default: telescope.nvim | telescope\|preview_scrolling_right | callback |
| n | <C-Q> | plugin default: telescope.nvim | telescope\|send_to_qflist + open_qflist | callback |
| n | <C-T> | plugin default: telescope.nvim | telescope\|select_tab | callback |
| n | <C-U> | plugin default: telescope.nvim | telescope\|preview_scrolling_up | callback |
| n | <C-V> | plugin default: telescope.nvim | telescope\|select_vertical | callback |
| n | <C-X> | plugin default: telescope.nvim | telescope\|select_horizontal | callback |
| n | <CR> | plugin default: telescope.nvim | telescope\|select_default | callback |
| n | <Down> | plugin default: telescope.nvim | telescope\|move_selection_next | callback |
| n | <Esc> | plugin default: telescope.nvim | telescope\|close | callback |
| n | <LeftMouse> | plugin default: telescope.nvim | telescope\|mouse_click | callback |
| n | <M-f> | plugin default: telescope.nvim | telescope\|results_scrolling_left | callback |
| n | <M-k> | plugin default: telescope.nvim | telescope\|results_scrolling_right | callback |
| n | <M-q> | plugin default: telescope.nvim | telescope\|send_selected_to_qflist + open_qflist | callback |
| n | <PageDown> | plugin default: telescope.nvim | telescope\|results_scrolling_down | callback |
| n | <PageUp> | plugin default: telescope.nvim | telescope\|results_scrolling_up | callback |
| n | <S-Tab> | plugin default: telescope.nvim | telescope\|toggle_selection + move_selection_better | callback |
| n | <Tab> | plugin default: telescope.nvim | telescope\|toggle_selection + move_selection_worse | callback |
| n | <Up> | plugin default: telescope.nvim | telescope\|move_selection_previous | callback |
| n | ? | plugin default: telescope.nvim | telescope\|which_key | callback |
| n | G | plugin default: telescope.nvim | telescope\|move_to_bottom | callback |
| n | H | plugin default: telescope.nvim | telescope\|move_to_top | callback |
| n | L | plugin default: telescope.nvim | telescope\|move_to_bottom | callback |
| n | M | plugin default: telescope.nvim | telescope\|move_to_middle | callback |
| n | gg | plugin default: telescope.nvim | telescope\|move_to_top | callback |
| n | j | plugin default: telescope.nvim | telescope\|move_selection_next | callback |
| n | k | plugin default: telescope.nvim | telescope\|move_selection_previous | callback |

## Classification notes

The tables above classify mappings by scope and runtime source. Paths under `.config/nvim` or `~/.config/nvim` are user configuration or plugin setup supplied by that configuration; installed plugin paths are plugin-defined mappings; `/usr/share/nvim` paths are Neovim runtime defaults. A `Lua` or `runtime/generated` source is unresolved provenance and should not be treated as proof of a user-defined key. Custom setup is concentrated in `lua/config/keymaps.lua`, `lua/plugins/{ui,telescope,lsp,formatting,multicursor}.lua`, `plugin/{navigation,ctrl-backspace,visual-editing}.lua`, `after/plugin/go.lua`, and `lua/kickstart/plugins/neo-tree.lua`. The tracked `plugin/visual-editing.lua` is absent from the independent live config; the live config has extra Insert `<C-CR>` and the shadowed Insert `<C-BS>` definition.

## Tracked multicursor correction

The tables above remain snapshots of the **separate live** `~/.config/nvim`, where visual-multi's default `<C-W>` add-word mapping is still present. The tracked configuration now sets `add_cursor_word = '<leader>mw'` in `lua/plugins/multicursor.lua`. A disposable copy of the tracked config confirmed the effective Normal `<leader>mw` add-word action and native `<C-W>h/l` navigation. The live configuration was not changed by this correction.
