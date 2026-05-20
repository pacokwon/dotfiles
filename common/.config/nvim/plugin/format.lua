vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = true,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = {
      c = true,
      css = true,
      ocamllex = true,
      menhir = true,
      html = true,
    }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    -- markdown = { 'markdownlint-cli2' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
    -- javascript = { 'deno_fmt' },
    cpp = { 'clang-format' },
    typescript = { 'biome' },
  },
}

vim.keymap.set('n', 'gff', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end)
