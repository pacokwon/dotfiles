vim.pack.add { 'https://github.com/Julian/lean.nvim' }

require('lean').setup { mappings = true }

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})
require('render-markdown').setup({})
