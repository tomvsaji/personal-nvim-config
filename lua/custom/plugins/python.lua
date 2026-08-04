-- Python debugging on top of nvim-dap.
--
-- mason-nvim-dap already gives you a plain "launch this file" config via
-- debugpy. This adds the part that actually matters day to day: starting the
-- debugger on the single test under your cursor instead of the whole file.

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-dap-python',
  ft = 'python',
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    -- debugpy lives in its own venv under Mason, separate from the project's
    -- interpreter, so the debugger works even in a venv that lacks debugpy.
    -- Windows venvs use Scripts\python.exe instead of bin/python.
    local subdir = vim.fn.has 'win32' == 1 and 'Scripts' or 'bin'
    local exe = vim.fn.has 'win32' == 1 and 'python.exe' or 'python'
    require('dap-python').setup(vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'packages', 'debugpy', 'venv', subdir, exe))
    require('dap-python').test_runner = 'pytest'

    local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { desc = 'Debug: ' .. desc }) end
    map('<leader>dm', function() require('dap-python').test_method() end, 'Test [M]ethod')
    map('<leader>dc', function() require('dap-python').test_class() end, 'Test [C]lass')
    vim.keymap.set('v', '<leader>ds', function() require('dap-python').debug_selection() end, { desc = 'Debug: [S]election' })
  end,
}
