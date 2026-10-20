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

-- compile & run the current file in a terminal split
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
