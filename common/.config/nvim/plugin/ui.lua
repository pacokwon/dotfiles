vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
}

vim.keymap.set('v', '<leader>fo', function()
  require('oil').open_float()
end, { silent = true })

require('bufferline').setup {}

require('todo-comments').setup { signs = false }

require('ibl').setup()
