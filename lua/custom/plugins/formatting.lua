-- Formatting.
--
-- Language servers disagree about who formats what: several of the servers in
-- init.lua will happily format a buffer, and some do it badly. conform makes
-- the choice explicit per filetype and falls back to the LSP only where nothing
-- is listed here.
--
-- Formatting is deliberately NOT run on save. These formatters reformat the
-- whole file, so on a project whose style differs from the default you would
-- get a huge unrelated diff the first time you touched any file. Use <leader>f.
-- To opt in later, add a `format_on_save` function to `opts` below.

---@module 'lazy'
---@type LazySpec
return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = { 'n', 'x' },
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },

      -- ruff replaces black + isort; organize imports first so the formatter
      -- gets the final say on line breaks.
      python = { 'ruff_organize_imports', 'ruff_format' },

      sh = { 'shfmt' },
      bash = { 'shfmt' },
      zsh = { 'shfmt' },

      toml = { 'taplo' },

      -- prettierd is a warm daemon; prettier is the cold fallback for when it
      -- is unavailable. stop_after_first means only one of them ever runs.
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
