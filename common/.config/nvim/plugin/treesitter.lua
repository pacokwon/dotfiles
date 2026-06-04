vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
}

local parsers = {
  'bash',
  'c',
  'css',
  'diff',
  'go',
  'gitcommit',
  'html',
  'javascript',
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
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if not lang then return end
    if not pcall(vim.treesitter.start) then
      if not require('nvim-treesitter.parsers')[lang] then return end
      require('nvim-treesitter').install({ lang }):wait()
      pcall(vim.treesitter.start)
    end
  end,
})
require('nvim-treesitter').install(parsers)

vim.filetype.add {
  extension = {
    spectec = 'spectec',
    watsup = 'spectec',
    mll = 'ocamllex',
    mly = 'menhir',
    stf = 'config',
    p4 = 'p4',
  },
}

vim.treesitter.language.register('p4', 'p4')

local function register_custom_parsers()
  local ts_parsers = require('nvim-treesitter.parsers')

  ts_parsers.spectec = {
    install_info = {
      path = '/Users/pacokwon/workspace/tree-sitter-spectec/',
    },
  }

  ts_parsers.lean = {
    install_info = {
      url = 'https://github.com/Julian/tree-sitter-lean',
    }
  }

  ts_parsers.p4 = {
    install_info = {
      url = 'https://github.com/pacokwon/tree-sitter-p4',
      -- path = '/Users/pacokwon/workspace/tree-sitter-p4/',
      queries = 'queries'
    },
  }
end

register_custom_parsers()

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = register_custom_parsers,
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
