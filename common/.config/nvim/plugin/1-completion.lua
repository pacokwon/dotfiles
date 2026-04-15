vim.pack.add {
  'https://github.com/folke/lazydev.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') }
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
    default = { 'lsp', 'buffer', 'path', 'snippets', 'lazydev' },
    providers = {
      lazydev = {
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },
  fuzzy = { implementation = 'lua' },
  cmdline = {
    keymap = { preset = 'inherit' },
    completion = { menu = { auto_show = true } },
  },
}
