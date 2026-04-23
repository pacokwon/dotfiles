---@diagnostic disable: missing-fields

-- INFO: introduction
-- this is a minimal neovim configuration written in lua. this is not meant to
-- be a distribution, but rather a template for you to build upon and/or a
-- reference for how to configure neovim using lua in the latest version.

-- INFO: options
-- these change the default neovim behaviours using the 'vim.opt' API.
-- see `:h vim.opt` for more details.
-- run `:h '{option_name}'` to see what they do and what values they can take.
-- for example, `:h 'number'` for `vim.opt.number`.

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.o.termguicolors = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'
vim.o.guicursor = ''

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
--
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- add a newline below the cursor
vim.keymap.set('n', '<leader>o', 'o<ESC>k0')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', 'gl', function()
  vim.diagnostic.open_float()
end, { desc = '[G]oto Diagnostic on Current [L]ine' })
vim.keymap.set('n', 'gn', function()
  vim.diagnostic.jump { count = 1, float = false }
end, { desc = '[G]oto [N]ext Diagnostic' })

vim.keymap.set('n', 'gp', function()
  vim.diagnostic.jump { count = -1, float = false }
end, { desc = '[G]oto [P]revious Diagnostic' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- line navigation
vim.keymap.set('n', '<C-j>', '10j', { desc = 'Move 10 lines down' })
vim.keymap.set('n', '<C-k>', '10k', { desc = 'Move 10 lines up' })
vim.keymap.set('v', '<C-j>', '10j', { desc = 'Move 10 lines down' })
vim.keymap.set('v', '<C-k>', '10k', { desc = 'Move 10 lines up' })

-- buffer navigation
vim.keymap.set('n', '<C-N>', '<cmd>bnext<CR>', { desc = 'Goto Next Buffer' })
vim.keymap.set('n', '<C-P>', '<cmd>bprevious<CR>', { desc = 'Goto Previous Buffer' })

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
  jump = {
    float = true,
    wrap = true,
  },
}

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- line navigation
vim.keymap.set('n', '<C-j>', '10j', { desc = 'Move 10 lines down' })
vim.keymap.set('n', '<C-k>', '10k', { desc = 'Move 10 lines up' })
vim.keymap.set('v', '<C-j>', '10j', { desc = 'Move 10 lines down' })
vim.keymap.set('v', '<C-k>', '10k', { desc = 'Move 10 lines up' })

-- buffer navigation
vim.keymap.set('n', '<C-N>', '<cmd>bnext<CR>', { desc = 'Goto Next Buffer' })
vim.keymap.set('n', '<C-P>', '<cmd>bprevious<CR>', { desc = 'Goto Previous Buffer' })

vim.keymap.set('n', '<leader>r', function()
  local filename = vim.fn.expand '%:p' -- full path of current file
  local output = vim.fn.expand '%:p:r' -- file path without extension

  local input = ''
  local input_prompt = ''
  local cmd = ''
  if vim.bo.filetype == 'c' or vim.bo.filetype == 'cpp' then
    if vim.loop.fs_stat 'input.txt' then
      input = ' < ' .. 'input.txt'
      input_prompt = 'echo "input.txt found. Piping to stdin...";'
    end

    cmd = string.format('g++ -std=c++20 -O2 %s -o %s && %s%s', filename, output, output, input)
  elseif vim.bo.filetype == 'python' then
    cmd = string.format('python %s', filename)
  end

  -- Open a horizontal split terminal and run the command
  vim.cmd(string.format('vsp | terminal %s %s', input_prompt, cmd))
  -- Optional: enter insert mode in the terminal automatically
  vim.cmd 'startinsert'
end, { noremap = true, silent = true })

vim.api.nvim_create_user_command('TOhtmlSelection', function()
  local function inline_with_juice(in_path)
    local out_path = vim.fn.tempname() .. '.inlined.html'
    local cmd = { 'npx', '--yes', 'juice', '--extra-css',
      '* { font-family: Roboto Mono, monospace; font-weight: 500 }', in_path, out_path }
    local res = vim.system(cmd, { text = true }):wait()

    if res.code ~= 0 then
      vim.notify('juice failed:\n' .. (res.stderr or ''), vim.log.levels.ERROR)
      return nil
    end

    return out_path
  end

  -- Get visual selection line range from marks '< and '>
  local s = vim.fn.getpos "'<" -- {bufnum, lnum, col, off}
  local e = vim.fn.getpos "'>"

  local start_line, end_line = s[2], e[2]
  if start_line == 0 or end_line == 0 then
    vim.notify('No visual selection found', vim.log.levels.WARN)
    return
  end
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Optional: disable indent guides so virtual text doesn't get captured
  pcall(vim.cmd, 'IBLDisable')

  local winid = vim.api.nvim_get_current_win()
  local lines = require('tohtml').tohtml(winid, {
    range = { start_line, end_line }, -- 1-based inclusive line range
  })

  pcall(vim.cmd, 'IBLEnable')

  local tmp_in = vim.fn.tempname() .. '.html'
  vim.fn.writefile(lines, tmp_in)

  local tmp_out = inline_with_juice(tmp_in)
  if not tmp_out then
    return
  end

  vim.cmd('silent !open ' .. vim.fn.fnameescape(tmp_out))
end, { range = true })

vim.keymap.set('v', '<leader>H', ':TOhtmlSelection<CR>', { silent = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.pack.add({
  'https://github.com/NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  'https://github.com/rightson/vim-p4-syntax',

  'https://github.com/tpope/vim-surround',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/j-hui/fidget.nvim',
}, { confirm = false })

vim.pack.add { 'https://github.com/folke/which-key.nvim' }

require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
    -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
    -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
    keys = vim.g.have_nerd_font and {} or {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = '<C-…> ',
      M = '<M-…> ',
      D = '<D-…> ',
      S = '<S-…> ',
      CR = '<CR> ',
      Esc = '<Esc> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  },
}

-- uncomment to enable automatic plugin updates
-- vim.pack.update()
