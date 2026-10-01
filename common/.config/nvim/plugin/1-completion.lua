vim.pack.add {
  'https://github.com/folke/lazydev.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' },
  'https://github.com/erooke/blink-cmp-latex',
}

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  sources = {
    default = { 'lsp', 'buffer', 'path', 'snippets', 'lazydev', 'latex' },
    providers = {
      lazydev = {
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      latex = {
        name = 'Latex',
        module = 'blink-cmp-latex',
        score_offset = 90,
        -- Only enable in LaTeX/markdown. This source registers `_` (subscript)
        -- as a trigger character; in code buffers that makes typing
        -- `_` mid-identifier fire a fresh empty completion and drop the LSP menu.
        enabled = function()
          return vim.tbl_contains({ 'tex', 'latex', 'markdown', 'quarto' }, vim.bo.filetype)
        end,
        opts = {
          insert_command = false,
        }
      }
    },
  },
  fuzzy = { implementation = 'prefer_rust' },
  cmdline = {
    keymap = { preset = 'inherit' },
    completion = { menu = { auto_show = true } },
  },
}
