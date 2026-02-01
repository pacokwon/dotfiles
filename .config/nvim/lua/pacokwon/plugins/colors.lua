local colorschemes = {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    'folke/tokyonight.nvim',
    name = 'tokyonight',
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
    name = 'github-nvim-theme',
    config = function()
      -- vim.cmd.colorscheme 'github_dark_default'
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2d2f38' })
      vim.api.nvim_set_hl(0, 'FugitiveHash', { link = 'Number' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
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

      -- vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    name = 'oxocarbon',
    config = function()
      vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#202020' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    end,
  },
  {
    'navarasu/onedark.nvim',
    name = 'onedark',
    config = function()
      require('onedark').setup {
        style = 'darker',
      }
      require('onedark').load()
    end,
  },
}

local plugin_name = 'catppuccin'
local variant = 'catppuccin-mocha'
if variant ~= nil then
  COLORSCHEME = variant
else
  COLORSCHEME = plugin_name
end

for _, entry in ipairs(colorschemes) do
  if entry.name == plugin_name then
    entry.priority = 1000
  else
    entry.priority = nil
    entry.config = nil
  end
end

return colorschemes
