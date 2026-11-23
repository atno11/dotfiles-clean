# Neovim keymap and idle-save audit

The effective runtime is `/home/atno/.config/nvim`, a separate directory from this repository's `.config/nvim`. The live config has an untracked `lua/config/autosave.lua`, but its `init.lua` no longer loads it. The repository never loaded an autosave module. Neither active init contains an idle write timer. The live configuration also has an extra Insert `<C-CR>`, different blink completion options, and an Insert `<C-BS>` definition that the later plugin script overrides. Those differences were preserved.

The [effective mapping inventory](nvim-keymap-inventory.md) records 400 global and buffer-local map entries captured with `nvim_get_keymap`, `nvim_buf_get_keymap`, and `:verbose map` in the live configuration. It includes installed plugin mappings and representative Lua, Go, TypeScript, JSON, and Markdown buffers. LSP attachment and plugin-specific UI states can add further maps; terminal input still needs physical validation. `Lua` in the source column is Neovim's runtime provenance when a more precise source was unavailable.

## Collision and precedence findings

| Keys | Finding | Disposition |
|---|---|---|
| Insert `<C-BS>` | The earlier `config/keymaps.lua` map is replaced by `plugin/ctrl-backspace.lua`; effective behavior deletes a preceding filename/path segment. | Removed the dead repository definition in `178ee36`. The live copy still contains it; effective behavior is unchanged. |
| Insert `<C-S-CR>` | The config maps it to open a line above. Blink config lists `fallback` for this key, so it does not claim a different action. | No change; physical terminal sequence pending. |
| Normal/Visual `<C-D>` and `<C-N>` | visual-multi.nvim defines find-next and select-all, superseding native scrolling/completion behavior in those modes. | Intentional plugin behavior; no change. |
| Normal `<F24>` | Maps to Telescope LSP references. | No conflicting effective map found; keyboard delivery pending. |
| Go `<F5>` | Buffer-local DAP continue map takes precedence in Go buffers. | Intended; no change. |
| LSP `gr*` and `gO` | Buffer-local LSP/Telescope maps appear after LSP attach and supersede applicable globals or built-ins. | Intended; no change. |

Ctrl+Shift letter combinations and F24 depend on terminal encoding. Neovim's map table proves registration, not that a particular terminal sends distinct bytes. Test them in the user's actual terminal, including Ctrl+Shift+Enter, Ctrl+Shift+P/F/O, F24, and Ctrl+Backspace.

## Fixed checklist

| ID | Result | Evidence and remaining work |
|---|---|---|
| NV-01 | PASS | Branch `fix/nvim-keymaps-no-idle-autosave`, HEAD `178ee36` at test start; only untracked `nvim.log`. Live config is a separate directory. Neovim 0.12.6 on Arch. |
| NV-02 | PENDING | Inventory has 400 effective entries, modes, scope, source, description, and action. Dynamically generated maps in untested plugin UI states remain to capture. |
| NV-03 | PENDING | Effective `<C-BS>`, `<C-S-CR>`, `<C-D>`, `<C-N>`, `<F24>`, Go F5 and LSP map precedence captured. Only verified dead duplicate was removed; a full dynamic-map collision check remains. |
| NV-04 | PASS | PTY test asserted `mode=i` in Insert and Append, then waited 6.5 seconds in each. Both remained modified; disk stayed `seed` and nanosecond mtime stayed unchanged. |
| NV-05 | PASS | Both PTY buffers remained modified and unwritten after Escape/InsertLeave. Separate temporary JSON test: Ctrl+S wrote `{ "a": 2 }`, and `:w` wrote `{ "a": 3 }`. |
| NV-06 | PASS | PTY test compared buffer text and cursor before and after each 6.5-second interval; both were unchanged. Disk and mtime were unchanged. |
| NV-07 | PASS | Manual `conform.format` on temporary JSON changed buffer text to `{ "longKey": 4 }` and left it modified. Explicit JSON saves formatted output through the existing Conform save policy. |
| NV-08 | PENDING | Global, Lua, Go, TypeScript, JSON, and Markdown maps captured. Physical terminal key delivery and behavior in additional UI modes need manual testing. |
| NV-09 | PENDING | Normal Down moved to line 2; Ctrl+H moved between splits; Ctrl+Shift+C copied to `+`; Go F5 buffer map registered. visual-multi Ctrl+D remained in normal mode in headless testing, so its interaction needs a PTY check. Neo-tree opened but its asynchronous renderer failed after headless teardown. LSP and Git map behavior was not established by the headless workflow test. |
| NV-10 | PENDING | Clean live startup outside sandbox returned exit 0; 34 repository Lua files parsed; `git diff --check` passed. No project test script exists. The headless Markdown buffer reported missing `markdownlint`; Neo-tree teardown produced an asynchronous invalid-window error. Final Git status must be checked after this report is committed. |

The PTY test recorded active mode, modified flag, disk contents, nanosecond mtime, cursor, and buffer text before/after idle and after InsertLeave. Its temporary files and scripts are under `/tmp`. Sandbox-only plugin permission errors disappeared when startup ran with normal user-data access. No permissions were changed.
