vim.pack.add {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/github/copilot.vim",
  "https://github.com/olimorris/codecompanion.nvim",
}

require("codecompanion").setup({
  opts = {
    log_level = "DEBUG",
  }
})
