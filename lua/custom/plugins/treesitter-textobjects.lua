-- Treesitter text objects: real function/class objects, and movement between them.
--
-- mini.ai already covers function *calls* (`f`) and arguments (`a`). This adds
-- the things that need a syntax tree: function and class *definitions*, loops,
-- and jumping between them.
--
-- NOTE: must track the `main` branch to match nvim-treesitter, which is also on
-- `main` in init.lua. The `master` branch has a different, incompatible API.

---@module 'lazy'
---@type LazySpec
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    -- Several built-in ftplugins (python, ruby, rust, go, …) map ]m/[m/]]/[[
    -- buffer-locally, which would shadow the treesitter versions below in
    -- exactly the languages that matter. Those built-ins are regex-based and
    -- less accurate, so turn them off and let treesitter answer instead.
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        -- Jump forward to the object if the cursor is not already inside one.
        lookahead = true,
        selection_modes = {
          -- Definitions are whole lines; selecting them charwise leaves ragged
          -- ends and breaks indentation on paste.
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
      },
      move = { set_jumps = true }, -- so Ctrl-o comes back
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'
    local swap = require 'nvim-treesitter-textobjects.swap'

    -- Text objects. `m` for method rather than `f`, because mini.ai already
    -- owns `f` for function calls and both are worth having.
    -- stylua: ignore
    local objects = {
      { 'am', '@function.outer', 'a function/method (definition)' },
      { 'im', '@function.inner', 'inside a function/method body' },
      { 'ac', '@class.outer',    'a class' },
      { 'ic', '@class.inner',    'inside a class body' },
      { 'al', '@loop.outer',     'a loop' },
      { 'il', '@loop.inner',     'inside a loop body' },
    }
    for _, o in ipairs(objects) do
      vim.keymap.set({ 'x', 'o' }, o[1], function() select.select_textobject(o[2], 'textobjects') end, { desc = o[3] })
    end

    -- Movement. ]m/[m and ]]/[[ follow the long-standing Vim convention for
    -- method and section jumps.
    -- stylua: ignore
    local moves = {
      { ']m', move.goto_next_start,     '@function.outer', 'Next function start' },
      { ']M', move.goto_next_end,       '@function.outer', 'Next function end' },
      { '[m', move.goto_previous_start, '@function.outer', 'Previous function start' },
      { '[M', move.goto_previous_end,   '@function.outer', 'Previous function end' },
      { ']]', move.goto_next_start,     '@class.outer',    'Next class start' },
      { '[[', move.goto_previous_start, '@class.outer',    'Previous class start' },
    }
    for _, m in ipairs(moves) do
      vim.keymap.set({ 'n', 'x', 'o' }, m[1], function() m[2](m[3], 'textobjects') end, { desc = m[4] })
    end

    -- Reorder function parameters without retyping them.
    vim.keymap.set('n', '<leader>a', function() swap.swap_next '@parameter.inner' end, { desc = 'Swap p[a]rameter with next' })
    vim.keymap.set('n', '<leader>A', function() swap.swap_previous '@parameter.inner' end, { desc = 'Swap p[A]rameter with previous' })
  end,
}
