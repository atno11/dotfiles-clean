-- ============================================================
-- GO TOOLCHAIN BOOTSTRAP
-- ============================================================
--
-- Installs Go editor dependencies.
-- Language server, formatting and debugging configuration
-- remain in after/plugin/go.lua.
--
-- Mason packages:
--   gopls
--   goimports
--
-- Treesitter parsers:
--   go
--   gomod
--   gowork
--   gosum
-- ============================================================

local registry = require('mason-registry')

local mason_packages = {
  'gopls',
  'goimports',
}

local parsers = {
  'go',
  'gomod',
  'gowork',
  'gosum',
}

-- ============================================================
-- MASON
-- ============================================================

local function ensure_mason_packages()
  registry.refresh(function()
    for _, name in ipairs(mason_packages) do
      if not registry.has_package(name) then
        vim.schedule(function()
          vim.notify(
            'Go toolchain: unknown package ' .. name,
            vim.log.levels.ERROR
          )
        end)
      else
        local package = registry.get_package(name)

        if not package:is_installed()
          and not package:is_installing() then
          local ok, err = pcall(function()
            package:install({}, function(success, result)
              if not success then
                vim.schedule(function()
                  vim.notify(
                    'Go toolchain: failed to install '
                      .. name .. ': '
                      .. vim.inspect(result),
                    vim.log.levels.ERROR
                  )
                end)
              end
            end)
          end)

          if not ok then
            vim.schedule(function()
              vim.notify(
                'Go toolchain: unable to start '
                  .. name .. ': ' .. tostring(err),
                vim.log.levels.ERROR
              )
            end)
          end
        end
      end
    end
  end)
end

-- ============================================================
-- TREESITTER
-- ============================================================

local function ensure_treesitter_parsers()
  require('nvim-treesitter').install(parsers)
end

-- ============================================================
-- INITIALIZATION
-- ============================================================

ensure_mason_packages()
ensure_treesitter_parsers()
