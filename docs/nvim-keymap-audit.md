# Neovim keymap and idle-save audit

The effective runtime is `/home/atno/.config/nvim`, a separate directory from this repository's `.config/nvim`. The live config has an untracked `lua/config/autosave.lua`, but its `init.lua` no longer loads it. The repository never loaded an autosave module. Neither active init contains an idle write timer. The live configuration also has an extra Insert `<C-CR>`, different blink completion options, and an Insert `<C-BS>` definition that the later plugin script overrides. Those differences were preserved.

The [effective mapping inventory](nvim-keymap-inventory.md) records 400 initial global and filetype entries plus 218 entries from active Neo-tree, LSP, Gitsigns, and visual-multi states. It uses `nvim_get_keymap`, `nvim_buf_get_keymap`, and `:verbose map` in the live configuration. These are state snapshots; the same mapping can appear in multiple contexts. The physical keyboard results below supplement them. `Lua` in the source column is Neovim's runtime provenance when a more precise source was unavailable.

## Collision and precedence findings

| Keys | Finding | Disposition |
|---|---|---|
| Insert `<C-BS>` | The earlier `config/keymaps.lua` map is replaced by `plugin/ctrl-backspace.lua`; effective behavior deletes a preceding filename/path segment. | Removed the dead repository definition in `178ee36`. The live copy still contains it; effective behavior is unchanged. |
| Insert `<C-S-CR>` | The config maps it to open a line above. Blink config lists `fallback` for this key, so it does not claim a different action. | No change; user confirmed the physical shortcut passes. |
| Normal/Visual `<C-D>` and `<C-N>` | visual-multi.nvim defines find-next and select-all, superseding native scrolling/completion behavior in those modes. | Intentional plugin behavior; no change. |
| Normal `<F24>` | Maps to Telescope LSP references. | No conflicting effective map found; keyboard delivery pending. |
| Go `<F5>` | Buffer-local DAP continue map takes precedence in Go buffers. | Intended; no change. |
| LSP `gr*` and `gO` | Buffer-local LSP/Telescope maps appear after LSP attach and supersede applicable globals or built-ins. | Intended; no change. |
| Neo-tree `j`, `k`, arrows, `d`, `f`, `<CR>`, `P`, `\\` | Opening Neo-tree exposed buffer-local maps from its defaults and the live setup. The arrow and `j`/`k` callbacks have no runtime description, but match the setup's preview/navigation handlers. | Buffer-local precedence is intended; no change. |
| Gitsigns `]c`, `[c`, `<leader>h*`, `<leader>t*`, `ih` | Confirmed after Gitsigns attached to a tracked file. Buffer-local maps override applicable globals. `]c` moved to a changed hunk. | Intended; no change. |
| visual-multi session `i`, `u`, `<C-R>`, `<Esc>` and motions | A three-selection session installed transient buffer-local maps. Its `u` description also mentions lowercase selections because behavior depends on the plugin's session mode. | Mode-dependent plugin behavior; no change. |

Ctrl+Shift letter combinations and F24 depend on terminal encoding. Neovim's map table proves registration, not that a particular terminal sends distinct bytes. The user confirmed the physical tests below; F24 remains unverified.

Neovim's internal keycodes distinguish `<C-S-CR>` from `<C-CR>`, `<C-S-P/F/O>` from `<C-P/F/O>`, and `<C-BS>` from `<BS>`. This rules out an internal keycode alias. The available PTY injects keys programmatically; it cannot prove which bytes the user's physical keyboard and Ghostty session send. `xdotool getactivewindow` could not connect to the display. The user supplied the following physical test results after that limitation was recorded:

| Application | Physical shortcut | Result |
|---|---|---|
| Neovim | Ctrl+Shift+P, Ctrl+Shift+F, Ctrl+Shift+O | PASS (user confirmed) |
| Neovim | Ctrl+Shift+Enter, Ctrl+Backspace | PASS (user confirmed) |
| Neovim | Ctrl+D, Alt+Shift+F | PASS (user confirmed) |
| Ghostty | Ctrl+G then P, Ctrl+G then F, Ctrl+G then O | PASS (user confirmed) |

The Ghostty sequences correspond to `toggle_command_palette`, `start_search`, and `new_split:right` in the tracked Ghostty configuration. The Neovim results confirm those tested shortcuts in the user's environment; they do not establish F24 delivery.

To check the remaining F24 delivery in the user's terminal, run `:lua print(vim.fn.keytrans(vim.fn.getcharstr()))`, press F24, and compare the printed token with `:verbose nmap <F24>`. A wrong printed token is a terminal delivery issue; a correct token with a wrong mapping target is a mapping conflict.

The visual-multi PTY test used a temporary `foo foo foo` buffer. `<C-N>` created three selections. `iQ<Esc>` produced `Qfoo Qfoo Qfoo`; `u` restored `foo foo foo`, `<C-r>` restored the edited text, and `<Esc>` removed the session. A separate `<C-D>` press created one selection, consistent with its find-next behavior. Gitsigns attached to a tracked file in a temporary Git repository (`gitsigns_head=master`); `]c` moved the cursor from line 1 to the changed hunk on line 2. Neo-tree opened a real window and exposed 76 buffer-local map entries. A Lua buffer had `lua_ls` and `stylua` attached and exposed 55 buffer-local entries, including `grd`.

## Fixed checklist

| ID | Result | Evidence and remaining work |
|---|---|---|
| NV-01 | PASS | Branch `fix/nvim-keymaps-no-idle-autosave`, HEAD `178ee36` at test start; only untracked `nvim.log`. Live config is a separate directory. Neovim 0.12.6 on Arch. |
| NV-02 | PENDING | Inventory now has 400 initial entries plus 218 dynamic-state entries with mode, scope, source, intended behavior, and effective callback/RHS. Telescope picker, DAP UI, completion popup, and other transient UI states remain outside the capture. |
| NV-03 | PENDING | Effective `<C-BS>`, `<C-S-CR>`, `<C-D>`, `<C-N>`, `<F24>`, Go F5, LSP, Neo-tree, Gitsigns, and visual-multi precedence captured. The verified dead duplicate was removed. User-confirmed physical tests cover Ctrl+Backspace, Ctrl+Shift+Enter, and Ctrl+D; F24 and uncaptured UI states remain. |
| NV-04 | PASS | PTY test asserted `mode=i` in Insert and Append, then waited 6.5 seconds in each. Both remained modified; disk stayed `seed` and nanosecond mtime stayed unchanged. |
| NV-05 | PASS | Both PTY buffers remained modified and unwritten after Escape/InsertLeave. Separate temporary JSON test: Ctrl+S wrote `{ "a": 2 }`, and `:w` wrote `{ "a": 3 }`. |
| NV-06 | PASS | PTY test compared buffer text and cursor before and after each 6.5-second interval; both were unchanged. Disk and mtime were unchanged. |
| NV-07 | PASS | Manual `conform.format` on temporary JSON changed buffer text to `{ "longKey": 4 }` and left it modified. Explicit JSON saves formatted output through the existing Conform save policy. |
| NV-08 | PENDING | Global, Lua, Go, TypeScript, JSON, Markdown, Neo-tree, attached LSP, attached Gitsigns, and active visual-multi maps captured. User-confirmed physical Neovim tests passed for Ctrl+Shift+P/F/O/Enter, Ctrl+Backspace, Ctrl+D, and Alt+Shift+F. F24 and additional filetype/UI states remain untested. |
| NV-09 | PENDING | Normal Down moved to line 2; Ctrl+H moved between splits; Ctrl+Shift+C copied to `+`; visual-multi selection/edit/undo/redo/exit and Gitsigns `]c` passed. User-confirmed Neovim and Ghostty shortcuts above passed. Neo-tree opened and LSP attached, but picker, LSP action, Go DAP action, and physical clipboard behavior remain unexecuted. |
| NV-10 | PASS | Clean live startup outside sandbox returned exit 0; 34 repository Lua files parsed; no project test script exists; `git diff --check` passed. Sandbox-only plugin permission errors disappeared with normal user-data access. Final Git status was checked after the audit commit. |

The PTY test recorded active mode, modified flag, disk contents, nanosecond mtime, cursor, and buffer text before/after idle and after InsertLeave. Its temporary files and scripts are under `/tmp`. Sandbox-only plugin permission errors disappeared when startup ran with normal user-data access. No permissions were changed.

Idle autosave is disabled and validated: the live `init.lua` does not load its autosave timer, the tracked configuration has no autosave loader, and the mode-verified Insert and Append idle tests in NV-04 through NV-06 showed no automatic write, formatting, or cursor displacement. Explicit saves and manual formatting remain validated in NV-05 and NV-07.

Opening a Markdown sample reported `markdownlint` missing: active `plugin/html-lint.lua` requests it, but no `markdownlint` executable was found. This is a linter availability issue, not a keymap or autosave collision. The prior Neo-tree invalid-window message occurred when a headless test exited while its asynchronous renderer was opening; the PTY test kept the window open until map capture and closed cleanly. Neither observation led to a configuration edit.

## Phase 2: focused keymap validation

Baseline: PR #22 was merged into `main` at `507a6ac`. The working tree had only the preserved untracked `nvim.log`; other listed worktrees were left alone. This audit ran on `audit/nvim-keymaps-complete`, created from that clean `main`. The effective `/home/atno/.config/nvim` remains a separate, locally modified configuration. The tracked and live Ghostty configurations matched at preflight. The Neovim differences listed above remain; no live or tracked functional configuration was changed. Earlier idle-save and physical-key tests were accepted as prior evidence and were not repeated.

The inventory now has **680 state-specific entries**: the earlier 618 plus 62 active Telescope prompt maps. It distinguishes user configuration/setup paths, installed plugin mappings, Neovim runtime defaults, and unresolved generated sources. These are snapshots, not 680 unique shortcuts. The tracked configuration has 117 `vim.keymap.set` call sites in its active source paths; loops and plugin setups create more runtime maps. All seven requested modes (`n`, `i`, `x`, `s`, `o`, `c`, `t`) are represented where applicable. Some plugin UI states and generated provenance remain uncaptured, so exhaustive classification is pending.

### New behavior evidence

| Area | Safe fixture and action | Observed result |
|---|---|
| Window and multicursor collision | Two splits with `/tmp/km-cw.txt`; pressed Normal `<C-W>h` before any multicursor session | Focus stayed in window 1001 and visual-multi started a one-region selection. The effective Normal `<C-W>` map described “Visual Multi: add word.” `<C-h>` moved focus to window 1000. This is a verified interception of the native `<C-W>` command prefix. |
| Editing/navigation | `/tmp/km-edit-sample.txt`; Alt+Up/Down, Alt+Shift+Down, Shift+Backspace, undo/redo, Ctrl+Shift+X; buffer switch with Alt+Right | Lines moved up and back; `beta` duplicated; Shift+Backspace deleted the current line; undo/redo changed the temporary buffer; cut removed a line and placed it in `+`; Alt+Right selected the next buffer. |
| Tracked-only visual editing | Disposable copy of tracked `.config/nvim`, `/tmp/km-selection.txt`; Visual `(`, Tab, Shift+Tab | `one two` became `(one) two`; two selected lines indented and then returned to original indentation. The live config lacks `plugin/visual-editing.lua`, so these maps are tracked-runtime behavior only. |
| Insert to Select | Disposable tracked config and `/tmp/km-select-mode.txt`; Insert `<S-Left>`, then `X` | Mode changed `i → s → i`; `abc def` became `abX def`. This tests the tracked navigation setup; the live config lacks the tracked `<S-Left>` definition. |
| Multicursor line editing | `/tmp/km-vm-lines.txt`; two `<C-Down>` presses, `A!`, `oX`, Escape | Three cursors formed. Lines became `one!`, `two!`, `three!`, then `one!|X|two!|X|three!|X`; Escape ended the session. The earlier three-selection character edit and undo/redo result remains valid. |
| Telescope | Interactive PTY `find_files` in `/tmp/km-telescope-fixture`; typed `sample`, pressed Enter | Active `TelescopePrompt` exposed 62 maps; picker opened `/tmp/km-telescope-fixture/sample.txt`. |
| Neo-tree | Interactive PTY on `/tmp/km-neotree-fixture`; `j`, `P`, `P`, Enter and separate `f` create | `j` moved selection from the root to `a.txt` and opened automatic preview. First `P` closed preview; second reopened it. Enter opened `a.txt`; `f` created `created-by-audit.txt` only inside the temporary fixture. |
| LSP definition/references/rename | Disposable `/tmp/km-lsp-project/main.lua` with configured `lua_ls` explicitly started by the harness | One definition and two references were returned. Mapped `grd` moved from call line 4 to definition line 1. Mapped `grr` callback also moved from line 4 to line 1. Mapped `grn` callback renamed both in-buffer `greet` occurrences to `renamed`; disk stayed unchanged. The temporary project did not auto-attach in the harness, so automatic attachment is not proven here. |
| LSP code action | Same Lua fixture; invoked attached-buffer `gra` callback | Callback ran without error, but no applicable edit or selection was observed. A successful code-action application remains unverified. |
| Gitsigns | Disposable `/tmp/km-gitsigns` repository with two modified tracked files; `]c`, `<leader>hp`, `<leader>hs`, `<leader>hr` | `]c` moved line 1 → 2; preview opened a float; stage placed the `two → TWO` hunk for `a.txt` in the temporary index. Reset changed `b.txt`'s buffer line back to `two`, left the on-disk `TWO` untouched, and marked the buffer modified. |
| Go DAP | `/tmp/km-go-dap/main.go`, Go 1.27.3, Delve 1.27.1; mapped breakpoint, F5, F1, F6, F3 | Disposable program built and printed `42`. Delve verified the breakpoint at line 8. F5 stopped there; mapped F1/F6/F3 callbacks each produced a subsequent step stop. The test terminated the debug session. |

### Fixed Phase 2 checklist

Every KM item began **PENDING**. Its criterion stays fixed here; the final result reflects only executed evidence.

| ID | Fixed criterion | Final result | Evidence or limit |
|---|---|---|---|
| KM-01 | Every custom shortcut is classified by mode, source, scope, target action and effective mapping. | PENDING | The 680-entry inventory and classification notes cover active global, filetype, and selected plugin states in all applicable modes. Some generated sources and transient UI states remain unresolved. |
| KM-02 | All duplicates, shadowed mappings and intentional overrides are analyzed with effective precedence evidence. | PENDING | The earlier Insert `<C-BS>` shadowing, LSP/Go/Gitsigns/Neo-tree buffer precedence, Telescope prompt maps, and new `<C-W>` interception have evidence. An exhaustive audit of every transient plugin state remains open. |
| KM-03 | Custom editing, selection, clipboard, line movement, undo/redo and navigation shortcuts execute their intended behavior. | PENDING | Tested line movement, duplication, delete/cut, `+` clipboard, buffer navigation, wrap, indentation, Select-mode replacement, and undo/redo on temporary files. Other defined combinations and physical clipboard integration were not all exercised. |
| KM-04 | Multicursor shortcuts and mode transitions work without unintended interception of native window commands. | FAIL | Character and line multicursor workflows passed, but Normal `<C-W>h` did not change windows: the plugin's global `<C-W>` map started a selection. `<C-h>` still changed windows. |
| KM-05 | Neo-tree, Telescope, LSP and Gitsigns representative custom actions execute successfully in their appropriate runtime contexts. | PASS | PTY picker/file opening, Neo-tree navigation/preview/open/create, LSP definition/references/rename, and Gitsigns navigation/preview/stage/reset succeeded in disposable fixtures. No applicable LSP code-action edit was demonstrated. |
| KM-06 | Go DAP shortcuts execute against a safe debug fixture when the required tooling is available; otherwise report explicit environmental blockers. | PASS | Go and Delve were installed. A mapped breakpoint and F5/F1/F6/F3 callbacks produced a verified breakpoint and three step stops in `/tmp/km-go-dap`; no install was needed. |
| KM-07 | Remaining physical key-delivery questions, including F24, are resolved by evidence or retained as explicitly documented manual PENDING tests. | PENDING | Prior physical Neovim and Ghostty PASS results above are preserved. F24 was not physically delivered in this environment. PTY-injected keys cannot establish keyboard delivery. |
| KM-08 | The tracked configuration and effective configuration differences, validation outcomes, unresolved issues, and Git state are documented without unrelated changes. | PASS | This section records the independent live setup, verified outcomes, limits, and branch state. Only these two audit documents changed in Phase 2; `nvim.log` and other worktrees were preserved. |

### Conflict disposition and recommendations

1. **High impact, verified:** visual-multi's default Normal `<C-W>` “add word” map intercepts the native window command prefix. Keep the feature but move `add_cursor_word` to an unused sequence in `lua/plugins/multicursor.lua`, then retest `<C-W>h/j/k/l` and the replacement key. This is a proposed correction only; no mapping changed during the audit.
2. **Medium impact, configuration drift:** the tracked visual-editing plugin and Shift+Left/Right Insert-selection definitions are absent from the live configuration. Reconcile them deliberately if the live setup is meant to match tracked dotfiles. The live extra Insert `<C-CR>` and shadowed `<C-BS>` remain preserved.
3. **Low impact, unverified:** physically test F24 in Ghostty with `:lua print(vim.fn.keytrans(vim.fn.getcharstr()))`, then inspect `:verbose nmap <F24>`. Keep it PENDING until the emitted key token and action are observed. An LSP code action should be tested on a fixture that offers a known applicable action.

No new autosave, formatting, or save-policy test was run in Phase 2, and those configurations were not changed.
