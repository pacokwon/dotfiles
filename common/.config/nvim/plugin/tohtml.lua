-- Export a visual selection as styled HTML / RTF, via the builtin tohtml module.
vim.cmd.packadd 'nvim.tohtml'

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
  local colo = vim.g.colors_name
  pcall(vim.cmd.colorscheme, 'catppuccin-latte')

  local winid = vim.api.nvim_get_current_win()
  local lines = require('tohtml').tohtml(winid, {
    range = { start_line, end_line }, -- 1-based inclusive line range
  })

  pcall(vim.cmd.colorscheme, colo)
  pcall(vim.cmd, 'IBLEnable')

  local tmp_in = vim.fn.tempname() .. '.html'
  vim.fn.writefile(lines, tmp_in)

  local tmp_out = inline_with_juice(tmp_in)
  if not tmp_out then
    return
  end

  vim.cmd('silent !open ' .. vim.fn.fnameescape(tmp_out))
end, { range = true })

vim.api.nvim_create_user_command('TOKeynoteSelection', function()
  local s = vim.fn.getpos "'<"
  local e = vim.fn.getpos "'>"
  local start_line, end_line = s[2], e[2]
  if start_line == 0 or end_line == 0 then
    vim.notify('No visual selection found', vim.log.levels.WARN)
    return
  end
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  pcall(vim.cmd, 'IBLDisable')
  local colo = vim.g.colors_name
  pcall(vim.cmd.colorscheme, 'catppuccin-latte')

  local winid = vim.api.nvim_get_current_win()
  local lines = require('tohtml').tohtml(winid, {
    range = { start_line, end_line },
  })

  pcall(vim.cmd.colorscheme, colo)
  pcall(vim.cmd, 'IBLEnable')

  local html_raw = table.concat(lines, '\n')
  -- 1. Fix Neovim's leading hyphens in CSS class names (e.g., .-variable -> .hl-variable)
  local sanitized_html = html_raw:gsub('%.%-([%w_-]+)', '.hl-%1'):gsub('class="%-([%w_-]+)"', 'class="hl-%1"')

  -- 2. Strip background-color declarations entirely
  sanitized_html = sanitized_html:gsub('background%-color%s*:%s*#[%x]+;?', '')

  -- 3. Remove body styling rule so RTF does not inherit document canvas fill
  sanitized_html = sanitized_html:gsub('body%s*{[^}]*}', '')

  local tmp_html = vim.fn.tempname() .. '.html'
  local tmp_rtf = vim.fn.tempname() .. '.rtf'
  vim.fn.writefile(vim.split(sanitized_html, '\n'), tmp_html)

  -- Convert via textutil to an actual RTF file, then set RTF pasteboard directly
  local cmd = string.format(
    "textutil -convert rtf %s -output %s && osascript -e 'set the clipboard to (read (POSIX file \"%s\") as «class RTF »)'",
    vim.fn.shellescape(tmp_html),
    vim.fn.shellescape(tmp_rtf),
    tmp_rtf
  )

  local res = vim.fn.system(cmd)
  vim.fn.delete(tmp_html)
  vim.fn.delete(tmp_rtf)

  if vim.v.shell_error == 0 then
    vim.notify('Copied styled RTF to Keynote clipboard!', vim.log.levels.INFO)
  else
    vim.notify('Failed to copy: ' .. res, vim.log.levels.ERROR)
  end
end, { range = true })

vim.keymap.set('v', '<leader>H', ':TOhtmlSelection<CR>', { silent = true })
vim.keymap.set('v', '<leader>K', ':TOKeynoteSelection<CR>', { silent = true })
