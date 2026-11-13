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
    markdown = { 'dprint' },
    cpp = { 'clang-format' },
    typescript = { 'oxfmt', 'biome', stop_after_first = true },
    typescriptreact = { 'oxfmt', 'biome', stop_after_first = true },
    javascript = { 'oxfmt', 'biome', stop_after_first = true },
    javascriptreact = { 'oxfmt', 'biome', stop_after_first = true },
    json = { 'oxfmt' },
    jsonc = { 'oxfmt' },
  },
}

vim.keymap.set('n', 'gff', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end)
