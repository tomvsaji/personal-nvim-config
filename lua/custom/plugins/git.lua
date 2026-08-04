-- Git beyond the current buffer.
--
-- gitsigns (already configured) only knows about uncommitted changes in the
-- file you have open. These two cover the rest: reviewing a whole changeset at
-- once, and reading history.

---@module 'lazy'
---@type LazySpec
return {
  {
    -- Side-by-side diffs with a file panel. This is the "review a whole change"
    -- view, and its file-history mode is the closest thing to a git log tree.
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git [D]iff: review all changes' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git [F]ile history (this file)' },
      { '<leader>gl', '<cmd>DiffviewFileHistory<cr>', desc = 'Git [L]og (whole repo)' },
      { '<leader>gm', '<cmd>DiffviewOpen origin/HEAD...HEAD<cr>', desc = 'Git diff vs [M]ain' },
      { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Git: [Q]uit diff view' },
    },
    opts = {
      enhanced_diff_hl = true,
      -- Follows the same switch the rest of the config uses, so turning on
      -- vim.g.have_nerd_font lights up icons here too.
      use_icons = vim.g.have_nerd_font,
      view = {
        -- Show both sides of the change rather than a single merged buffer.
        merge_tool = { layout = 'diff3_mixed' },
      },
    },
  },

  {
    -- A full git UI in a buffer: stage, unstage, commit, branch, push, all from
    -- menus that tell you the keys. Discoverable in a way the CLI is not.
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it status (Neo[g]it)' },
      { '<leader>gc', '<cmd>Neogit commit<cr>', desc = 'Git [C]ommit' },
    },
    opts = {
      integrations = { diffview = true, telescope = true },
    },
  },
}
