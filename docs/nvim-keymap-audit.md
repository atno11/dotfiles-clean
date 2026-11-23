# Neovim keymap and idle-save audit

The effective runtime is `/home/atno/.config/nvim`, a separate directory from this repository's `.config/nvim`. The live config has an untracked `lua/config/autosave.lua`, but its `init.lua` no longer loads it. The repository never loaded an autosave module. Neither active init contains an idle write timer. The live configuration also has an extra Insert `<C-CR>`, different blink completion options, and an Insert `<C-BS>` definition that the later plugin script overrides. Those differences were preserved.

The [effective mapping inventory](nvim-keymap-inventory.md) records 400 initial global and filetype entries plus 218 entries from active Neo-tree, LSP, Gitsigns, and visual-multi states. It uses `nvim_get_keymap`, `nvim_buf_get_keymap`, and `:verbose map` in the live configuration. These are state snapshots; the same mapping can appear in multiple contexts. Terminal input still needs physical validation. `Lua` in the source column is Neovim's runtime provenance when a more precise source was unavailable.

## Collision and precedence findings

| Keys | Finding | Disposition |
|---|---|---|
| Insert `<C-BS>` | The earlier `config/keymaps.lua` map is replaced by `plugin/ctrl-backspace.lua`; effective behavior deletes a preceding filename/path segment. | Removed the dead repository definition in `178ee36`. The live copy still contains it; effective behavior is unchanged. |
| Insert `<C-S-CR>` | The config maps it to open a line above. Blink config lists `fallback` for this key, so it does not claim a different action. | No change; physical terminal sequence pending. |
| Normal/Visual `<C-D>` and `<C-N>` | visual-multi.nvim defines find-next and select-all, superseding native scrolling/completion behavior in those modes. | Intentional plugin behavior; no change. |
| Normal `<F24>` | Maps to Telescope LSP references. | No conflicting effective map found; keyboard delivery pending. |
| Go `<F5>` | Buffer-local DAP continue map takes precedence in Go buffers. | Intended; no change. |
| LSP `gr*` and `gO` | Buffer-local LSP/Telescope maps appear after LSP attach and supersede applicable globals or built-ins. | Intended; no change. |
| Neo-tree `j`, `k`, arrows, `d`, `f`, `<CR>`, `P`, `\\` | Opening Neo-tree exposed buffer-local maps from its defaults and the live setup. The arrow and `j`/`k` callbacks have no runtime description, but match the setup's preview/navigation handlers. | Buffer-local precedence is intended; no change. |
| Gitsigns `]c`, `[c`, `<leader>h*`, `<leader>t*`, `ih` | Confirmed after Gitsigns attached to a tracked file. Buffer-local maps override applicable globals. `]c` moved to a changed hunk. | Intended; no change. |
| visual-multi session `i`, `u`, `<C-R>`, `<Esc>` and motions | A three-selection session installed transient buffer-local maps. Its `u` description also mentions lowercase selections because behavior depends on the plugin's session mode. | Mode-dependent plugin behavior; no change. |

Ctrl+Shift letter combinations and F24 depend on terminal encoding. Neovim's map table proves registration, not that a particular terminal sends distinct bytes. Test them in the user's actual terminal, including Ctrl+Shift+Enter, Ctrl+Shift+P/F/O, F24, and Ctrl+Backspace.

Neovim's internal keycodes distinguish `<C-S-CR>` from `<C-CR>`, `<C-S-P/F/O>` from `<C-P/F/O>`, and `<C-BS>` from `<BS>`. This rules out an internal keycode alias. The available PTY injects keys programmatically; it cannot prove which bytes the user's physical keyboard and Ghostty session send. `xdotool getactivewindow` could not connect to the display. Physical delivery for all six requested shortcuts remains **PENDING**.

To complete that check in the user's terminal, run `:lua print(vim.fn.keytrans(vim.fn.getcharstr()))`, then press each requested key and record the printed token. Compare it with `:verbose nmap <key>` or `:verbose imap <key>` as appropriate. Test `<C-S-CR>` and `<C-BS>` in Insert mode after recording their tokens, and F24 and Ctrl+Shift+P/F/O in Normal mode. A wrong printed token is a terminal delivery issue; a correct token with a wrong `:verbose map` target is a mapping conflict.

The visual-multi PTY test used a temporary `foo foo foo` buffer. `<C-N>` created three selections. `iQ<Esc>` produced `Qfoo Qfoo Qfoo`; `u` restored `foo foo foo`, `<C-r>` restored the edited text, and `<Esc>` removed the session. A separate `<C-D>` press created one selection, consistent with its find-next behavior. Gitsigns attached to a tracked file in a temporary Git repository (`gitsigns_head=master`); `]c` moved the cursor from line 1 to the changed hunk on line 2. Neo-tree opened a real window and exposed 76 buffer-local map entries. A Lua buffer had `lua_ls` and `stylua` attached and exposed 55 buffer-local entries, including `grd`.

## Fixed checklist

| ID | Result | Evidence and remaining work |
|---|---|---|
| NV-01 | PASS | Branch `fix/nvim-keymaps-no-idle-autosave`, HEAD `178ee36` at test start; only untracked `nvim.log`. Live config is a separate directory. Neovim 0.12.6 on Arch. |
| NV-02 | PENDING | Inventory now has 400 initial entries plus 218 dynamic-state entries with mode, scope, source, intended behavior, and effective callback/RHS. Telescope picker, DAP UI, completion popup, and other transient UI states remain outside the capture. |
| NV-03 | PENDING | Effective `<C-BS>`, `<C-S-CR>`, `<C-D>`, `<C-N>`, `<F24>`, Go F5, LSP, Neo-tree, Gitsigns, and visual-multi precedence captured. The verified dead duplicate was removed. Physical keyboard reachability and uncaptured UI states remain. |
| NV-04 | PASS | PTY test asserted `mode=i` in Insert and Append, then waited 6.5 seconds in each. Both remained modified; disk stayed `seed` and nanosecond mtime stayed unchanged. |
| NV-05 | PASS | Both PTY buffers remained modified and unwritten after Escape/InsertLeave. Separate temporary JSON test: Ctrl+S wrote `{ "a": 2 }`, and `:w` wrote `{ "a": 3 }`. |
| NV-06 | PASS | PTY test compared buffer text and cursor before and after each 6.5-second interval; both were unchanged. Disk and mtime were unchanged. |
| NV-07 | PASS | Manual `conform.format` on temporary JSON changed buffer text to `{ "longKey": 4 }` and left it modified. Explicit JSON saves formatted output through the existing Conform save policy. |
| NV-08 | PENDING | Global, Lua, Go, TypeScript, JSON, Markdown, Neo-tree, attached LSP, attached Gitsigns, and active visual-multi maps captured. Physical terminal delivery for Ctrl+Shift+Enter/P/F/O, F24, and Ctrl+Backspace remains untested. |
| NV-09 | PENDING | Normal Down moved to line 2; Ctrl+H moved between splits; Ctrl+Shift+C copied to `+`; visual-multi selection/edit/undo/redo/exit and Gitsigns `]c` passed. Neo-tree opened and LSP attached, but picker, LSP action, Go DAP action, and physical clipboard/keyboard behavior remain unexecuted. |
| NV-10 | PASS | Clean live startup outside sandbox returned exit 0; 34 repository Lua files parsed; no project test script exists; `git diff --check` passed. Sandbox-only plugin permission errors disappeared with normal user-data access. Final Git status was checked after the audit commit. |

The PTY test recorded active mode, modified flag, disk contents, nanosecond mtime, cursor, and buffer text before/after idle and after InsertLeave. Its temporary files and scripts are under `/tmp`. Sandbox-only plugin permission errors disappeared when startup ran with normal user-data access. No permissions were changed.

Opening a Markdown sample reported `markdownlint` missing: active `plugin/html-lint.lua` requests it, but no `markdownlint` executable was found. This is a linter availability issue, not a keymap or autosave collision. The prior Neo-tree invalid-window message occurred when a headless test exited while its asynchronous renderer was opening; the PTY test kept the window open until map capture and closed cleanly. Neither observation led to a configuration edit.
