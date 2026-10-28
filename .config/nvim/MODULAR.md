# Mapa da configuração

`init.lua` carrega os módulos em ordem explícita. Edite:

- `lua/config/options.lua`: opções e líderes.
- `lua/config/diagnostics.lua`: configuração inicial dos diagnósticos.
- `lua/config/keymaps.lua`: atalhos gerais e estilo VS Code.
- `lua/config/autocmds.lua`: destaque ao copiar e criação de diretórios ao salvar.
- `lua/plugins/manager.lua`: hooks de instalação/atualização do `vim.pack`.
- `lua/plugins/ui.lua`: interface, Gitsigns, Which-key, mini.nvim e indentação. Carrega `plugins.theme` na posição original.
- `lua/plugins/theme.lua`: Catppuccin Mocha.
- `lua/plugins/telescope.lua`: busca, atalhos e mapeamentos de `LspAttach`.
- `lua/plugins/lsp.lua`: Mason, servidores e mapeamentos de `LspAttach`.
- `lua/plugins/formatting.lua`: Conform e seus formatos gerais.
- `lua/plugins/completion.lua`: LuaSnip, Blink e autopairs.
- `lua/plugins/treesitter.lua`: instalação e ativação de parsers.
- `lua/plugins/github.lua`: auxiliar de URL compartilhado pelos módulos de plugins.

`lua/kickstart/plugins/neo-tree.lua` continua carregado explicitamente após Treesitter. Os arquivos em `plugin/` e `after/plugin/` são carregados automaticamente pelo runtime do Neovim, portanto não devem receber um `require()` adicional. Entre eles estão navegação por setas, Ctrl+Backspace, apresentação de diagnósticos, TypeScript, Go, Prettier e Trim. Os exemplos em `lua/kickstart/plugins/` e o carregador `lua/custom/plugins/init.lua` continuam inativos.

A ordem relevante é: líder e opções; diagnósticos, atalhos e autocomandos; hook `PackChanged`; plugins de UI e tema; Telescope; LSP/Mason (`pack.add`, `setup`, `lsp.config`, `lsp.enable`); Conform; LuaSnip/Blink; Treesitter; Neo-tree; depois os scripts automáticos de `after/plugin/`. TypeScript e Go estendem Conform depois de seu `setup`, e a apresentação em `after/plugin/diagnostic-display.lua` sobrepõe apenas as opções de exibição dos diagnósticos.
