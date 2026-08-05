vim.pack.add {
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/projekt0n/github-nvim-theme',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/catppuccin/nvim',
  'https://github.com/miikanissi/modus-themes.nvim',
}

-- local colorschemes = {
--   { -- You can easily change to a different colorscheme.
--     -- Change the name of the colorscheme plugin below, and then
--     -- change the command in the config to whatever the name of that colorscheme is.
--     'folke/tokyonight.nvim',
--     name = 'tokyonight',
--     config = function()
--       ---@diagnostic disable-next-line: missing-fields
--       require('tokyonight').setup {
--         styles = {
--           comments = { italic = false }, -- Disable italics in comments
--         },
--       }
--     end,
--   },
--   {
--     'projekt0n/github-nvim-theme',
--     name = 'github-nvim-theme',
--     config = function()
--       -- vim.cmd.colorscheme 'github_dark_default'
--       vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#2d2f38' })
--       vim.api.nvim_set_hl(0, 'FugitiveHash', { link = 'Number' })
--       vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
--     end,
--   },
--   {
--     'ellisonleao/gruvbox.nvim',
--     name = 'gruvbox',
--     config = function()
--       require('gruvbox').setup {
--         contrast = 'hard',
--         overrides = {
--           SignColumn = {
--             bg = 'None',
--           },
--           DiffAdd = {
--             fg = '#b8bb26',
--             bg = 'None',
--           },
--           DiffDelete = {
--             fg = '#fb4934',
--             bg = 'None',
--           },
--           Visual = {
--             reverse = true,
--           },
--           ['@module.ocaml'] = {
--             fg = '#83a598',
--           },
--           ['@lsp.type.namespace.ocaml'] = {
--             fg = '#83a598',
--           },
--         },
--       }
--
--       -- vim.cmd.colorscheme 'gruvbox'
--     end,
--   },
--   {
--     'catppuccin/nvim',
--     name = 'catppuccin',
--   },
--   {
--     'nyoom-engineering/oxocarbon.nvim',
--     name = 'oxocarbon',
--     config = function()
--       vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#202020' })
--       vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
--     end,
--   },
--   {
--     'navarasu/onedark.nvim',
--     name = 'onedark',
--     config = function()
--       require('onedark').setup {
--         style = 'darker',
--       }
--       require('onedark').load()
--     end,
--   },
-- }

require('modus-themes').setup {
  on_highlights = function(highlights, colors)
    -- modus links RenderMarkdownCode -> markdownCodeBlock which sets fg=cyan_cooler,
    -- overriding injected treesitter highlights inside fenced code blocks.
    -- Use only a bg so injected syntax colors can show through.
    highlights['RenderMarkdownCode'] = { bg = colors.bg_main }
    highlights['@markup.raw.block'] = {}
    highlights['LineNr'] = { fg = colors.fg_main, bg = colors.bg_main }
    highlights['LineNrAbove'] = { fg = colors.fg_dim, bg = colors.bg_main }
    highlights['LineNrBelow'] = { fg = colors.fg_dim, bg = colors.bg_main }
    highlights['SignColumn'] = { fg = colors.fg_dim, bg = colors.bg_main }
  end,
}

-- vim.cmd.colorscheme 'catppuccin-mocha'

-- local plugin_name = 'catppuccin'
-- local variant = 'catppuccin-mocha'
-- if variant ~= nil then
--   COLORSCHEME = variant
-- else
--   COLORSCHEME = plugin_name
-- end
--
-- for _, entry in ipairs(colorschemes) do
--   if entry.name == plugin_name then
--     entry.priority = 1000
--   else
--     entry.priority = nil
--     entry.config = nil
--   end
-- end
--
-- return colorschemes

vim.cmd.colorscheme 'modus'
