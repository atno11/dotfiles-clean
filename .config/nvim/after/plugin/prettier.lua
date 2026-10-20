-- ============================================================
-- PRETTIER DEFAULT CONFIGURATION
-- Neovim / Conform
-- ============================================================

local conform = require('conform')

-- Apply personal defaults only when the project does not
-- provide its own Prettier configuration.
-- Preserve all existing formatter registrations.

conform.formatters.prettier = {
  prepend_args = {
    '--config-precedence', 'prefer-file',

    '--arrow-parens', 'always',
    '--bracket-same-line',
    '--bracket-spacing',
    '--embedded-language-formatting', 'auto',
    '--end-of-line', 'lf',
    '--jsx-single-quote',
    '--print-width', '80',
    '--prose-wrap', 'always',
    '--semi',
    '--single-attribute-per-line',
    '--single-quote',
    '--tab-width', '2',
    '--trailing-comma', 'all',
  },
}
