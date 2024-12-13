local M = {}

local checkForLockfile = function()
  local match = vim.fn.glob(vim.fn.getcwd() .. '/poetry.lock')
  if match ~= '' then
    vim.env.PYTHONPATH = vim.fn.getcwd()
    local poetry_venv = vim.fn.trim(vim.fn.system 'poetry env info -p')
    vim.env.VIRTUAL_ENV = poetry_venv
  end
end

M.setup = function()
  -- run on startup
  checkForLockfile()
  -- and when changing directory
  vim.api.nvim_create_autocmd({ 'DirChanged' }, {
    callback = function()
      checkForLockfile()
    end,
  })
end
M.setup()

require('lspconfig').pyright.setup {
  settings = {
    python = {
      pythonPath = vim.env.PYTHONPATH,
      venvPath = vim.env.VIRTUAL_ENV,
      analysis = {
        reportMissingImports = 'error',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
}
