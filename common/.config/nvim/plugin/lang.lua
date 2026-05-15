vim.pack.add {
  'https://github.com/Julian/lean.nvim',
  'https://github.com/whonore/coqtail',
  'https://github.com/tomtomjhj/vsrocq.nvim',
  'https://github.com/tomtomjhj/coq-lsp.nvim',
}

require('lean').setup { mappings = true }

vim.g.coqtail_treat_stderr_as_warning = 1
vim.g.loaded_coqtail = 1
vim.g['coqtail#supported'] = 0
-- require('vsrocq').setup {}
require('coq-lsp').setup {}

vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}
require('render-markdown').setup {}
