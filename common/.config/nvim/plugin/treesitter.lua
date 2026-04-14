vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
}

require('nvim-treesitter').setup {
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}

local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'go',
  'html',
  'javascript',
  'lean',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'menhir',
  'ocaml',
  'ocamllex',
  'python',
  'query',
  'rust',
  'typescript',
  'vim',
  'vimdoc',
  'spectec',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = parsers,
  callback = function() vim.treesitter.start() end,
})
require('nvim-treesitter').install(parsers)

vim.filetype.add {
  extension = {
    spectec = 'spectec',
    watsup = 'spectec',
    mll = 'ocamllex',
    mly = 'menhir',
    stf = 'config',
  },
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').spectec = {
      install_info = {
        path = '/Users/pacokwon/workspace/tree-sitter-spectec/',
        -- optional entries
        queries = 'queries', -- symlink queries from given directory
      },
    }
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})
