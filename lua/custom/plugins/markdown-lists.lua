-- Continue Markdown bullets, numbered lists, and task lists automatically.

---@module 'lazy'
---@type LazySpec
return {
  'gaoDean/autolist.nvim',
  ft = 'markdown',
  config = function()
    require('autolist').setup()

    vim.keymap.set('i', '<CR>', '<CR><cmd>AutolistNewBullet<cr>', {
      buffer = true,
      desc = 'Continue Markdown list',
    })
    vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>', {
      buffer = true,
      desc = 'Continue Markdown list below',
    })
    vim.keymap.set('n', 'O', 'O<cmd>AutolistNewBulletBefore<cr>', {
      buffer = true,
      desc = 'Continue Markdown list above',
    })
  end,
}
