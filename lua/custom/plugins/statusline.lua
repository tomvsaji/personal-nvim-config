-- LazyVim-style statusline. Replaces mini.statusline (commented out in init.lua).
--
-- Left:  mode | branch | diff counts | diagnostics | file path
-- Right: attached LSP names | filetype | progress | line:col

---@module 'lazy'
---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = function()
    -- Set before lualine loads so the layout doesn't jump on startup.
    vim.o.laststatus = 3 -- one global statusline instead of one per split
    vim.o.showmode = false -- mode is shown in the statusline already
  end,
  opts = {
    options = {
      theme = 'auto', -- follows the colorscheme
      globalstatus = true,
      icons_enabled = vim.g.have_nerd_font,
      component_separators = '',
      section_separators = { left = '', right = '' },
      disabled_filetypes = { statusline = { 'neo-tree' } },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
        {
          'diff',
          symbols = { added = '+', modified = '~', removed = '-' },
          -- gitsigns already tracks hunks; reuse it instead of re-diffing.
          source = function()
            local g = vim.b.gitsigns_status_dict
            if g then return { added = g.added, modified = g.changed, removed = g.removed } end
          end,
        },
        { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' } },
        { 'filename', path = 1, symbols = { modified = '●', readonly = '', unnamed = '[No Name]' } },
      },
      lualine_x = {
        {
          -- Names of attached language servers, e.g. "pyright, ruff".
          function()
            local names = vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients { bufnr = 0 })
            return #names > 0 and (' ' .. table.concat(names, ', ')) or ''
          end,
        },
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
