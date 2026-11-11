local M = {}

function M.setup()
  require('visual-multi').setup {
    case_sensitive = false,
    mappings = {
      find_next = '<C-d>',
      select_all = '<C-n>',
    },
  }
end

return M
