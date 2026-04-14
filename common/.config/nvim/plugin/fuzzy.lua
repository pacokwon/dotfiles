vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }

local fzf_lua = require 'fzf-lua'
fzf_lua.setup {
  files = {
    cwd_prompt = false,
  },
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
}
fzf_lua.register_ui_select()

vim.keymap.set('n', '<leader>sf', fzf_lua.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', fzf_lua.git_files, { desc = '[S]earch Files Respecting .[G]itignore' })
vim.keymap.set('n', '<leader>st', fzf_lua.live_grep_native, { desc = '[S]earch by [T]ext' })
vim.keymap.set('n', '<leader>sd', fzf_lua.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sw', fzf_lua.diagnostics_workspace, { desc = '[S]earch [W]orkspace Diagnostics' })
vim.keymap.set('n', '<leader>sr', fzf_lua.lsp_references, { desc = '[S]earch [R]eferences' })
vim.keymap.set('n', '<leader><leader>', fzf_lua.buffers, { desc = '[S]earch [R]eferences' })
