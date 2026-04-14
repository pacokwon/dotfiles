vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }

local MiniIcons = require 'mini.icons'

MiniIcons.setup()
require('mini.pairs').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_fileinfo = function(args)
  if statusline.is_truncated(args.trunc_width) then
    return ''
  end

  local icon, icon_hl = MiniIcons.get('file', vim.fn.expand '%:t')
  local ft = vim.bo.filetype
  local filename = string.format('%%#%s# %s  %s%%*', icon_hl, icon, ft)
  return filename
end

statusline.setup {
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = MiniStatusline.section_diff { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local location = MiniStatusline.section_location { trunc_width = 75 }
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFilename', strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      }
    end,
  },
  use_icons = true,
}
