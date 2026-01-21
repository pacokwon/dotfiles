return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      -- vim.cmd.colorscheme 'github_dark_default'
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2d2f38' })
      vim.api.nvim_set_hl(0, 'FugitiveHash', { link = 'Number' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = 'hard',
        overrides = {
          SignColumn = {
            bg = 'None',
          },
          DiffAdd = {
            fg = '#b8bb26',
            bg = 'None',
          },
          DiffDelete = {
            fg = '#fb4934',
            bg = 'None',
          },
          Visual = {
            reverse = true,
          },
          ['@module.ocaml'] = {
            fg = '#83a598',
          },
          ['@lsp.type.namespace.ocaml'] = {
            fg = '#83a598',
          },
        },
      }

      vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'oxocarbon'
      -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#202020' })
      -- vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    end,
  },
}
