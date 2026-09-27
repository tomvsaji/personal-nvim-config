-- Extra colorschemes. Tokyonight (in init.lua) stays installed; switch between
-- all of them live with `:Telescope colorscheme` (<leader>sc).

---@module 'lazy'
---@type LazySpec
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        no_italic = true, -- matches the no-italic-comments choice made for tokyonight
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true, -- loaded on demand when picked in the colorscheme picker
    opts = { commentStyle = { italic = false } },
  },
}
