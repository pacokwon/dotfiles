vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  -- nvim-java and its dependencies
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-java/nvim-java',
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('K', function()
      vim.lsp.buf.hover { border = 'rounded' }
    end, '[R]e[n]ame')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', require('fzf-lua').lsp_code_actions, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('grr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gri', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('grd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map('gO', require('fzf-lua').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map('gW', require('fzf-lua').lsp_workspace_symbols, 'Open Workspace Symbols')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('grt', require('fzf-lua').lsp_typedefs, '[G]oto [T]ype Definition')

    for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
      if client.name == 'biome' then
        map('gbf', function()
          local params = vim.lsp.util.make_range_params(0, 'utf-8')
          ---@diagnostic disable-next-line: inject-field
          params.context = { only = { 'source.fixAll.biome' } }
          vim.lsp.buf.code_action {
            context = params.context,
            apply = false, -- Neovim 0.10+: auto-apply first/only action
          }
        end, '[B]iome [F]ixAll')
      end
    end

    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        ---@diagnostic disable-next-line: param-type-mismatch
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      vim.lsp.inlay_hint.enable(true)

      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- registers the base jdtls config, so it must run before vim.lsp.config('jdtls', ...) below
require('java').setup {
  spring_boot_tools = { enable = false },
  -- use the nix-provided jdk21 (JAVA_HOME) instead of downloading one
  jdk = { path = vim.env.JAVA_HOME },
}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--  @class LspServersConfig
--  @field mason table<string, vim.lsp.Config>
--  @field others table<string, vim.lsp.Config>

-- True when the nearest node_modules has TypeScript 7+, whose language server
-- is `tsc --lsp` (handled by the `tsc` config) rather than tsserver (vtsls).
local function uses_ts7(bufnr)
  local root = vim.fs.root(bufnr, 'node_modules')
  local f = root and io.open(vim.fs.joinpath(root, 'node_modules/typescript/package.json'))
  if not f then
    return false
  end
  local ok, pkg = pcall(vim.json.decode, f:read('*a'))
  f:close()
  local version = ok and vim.version.parse((pkg or {}).version or '') or nil
  return version ~= nil and version.major >= 7
end

-- lspconfig's tsc config, captured before vim.lsp.config('tsc', ...) below
-- overrides it. Its cmd and root_dir share a private cache of the resolved
-- binary, so both must come from this same copy.
local tsc_base = vim.lsp.config.tsc

-- Wraps a server's own root detection so it only starts where its binary is
-- available (the project's node_modules/.bin or $PATH). Servers like oxlint
-- and tailwindcss otherwise attach to any package.json/.git project and error
-- in projects that don't use them.
local function when_installed(name, bin)
  local base_root_dir = vim.lsp.config[name].root_dir
  return {
    root_dir = function(bufnr, on_dir)
      base_root_dir(bufnr, function(root)
        local local_bin = root and vim.fs.joinpath(root, 'node_modules/.bin', bin)
        if (local_bin and vim.fn.executable(local_bin) == 1) or vim.fn.executable(bin) == 1 then
          on_dir(root)
        end
      end)
    end,
  }
end

local servers = {
  denols = {
    root_markers = { 'deno.json', 'deno.jsonc' },
    root_dir = function(_, callback)
      local root_dir = vim.fs.root(0, { 'deno.json', 'deno.jsonc' })

      if root_dir ~= nil then
        callback(root_dir)
      end
    end,
  },
  pyright = {},
  ruff = {},
  ocamllsp = {},
  biome = {},
  astro = {}, -- astro-ls comes from the project's nix devShell
  oxlint = when_installed('oxlint', 'oxlint'),
  tailwindcss = when_installed('tailwindcss', 'tailwindcss-language-server'),
  tsc = {
    -- Only attach in TypeScript 7+ projects; elsewhere vtsls handles TS and
    -- tsc would just warn that it found no `--lsp`-capable binary.
    cmd = tsc_base.cmd,
    root_dir = function(bufnr, on_dir)
      if uses_ts7(bufnr) then
        tsc_base.root_dir(bufnr, on_dir)
      end
    end,
  },
  vtsls = {
    root_dir = function(bufnr, callback)
      local deno_dir = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
      local root_dir = vim.fs.root(bufnr, { 'tsconfig.json', 'jsconfig.json', 'package.json' })

      if deno_dir == nil and not uses_ts7(bufnr) then
        callback(root_dir)
      end
    end,
  },
  nixd = {},
  metals = {},
  lua_ls = {
    -- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file("lua", true) },
      },
    },
  },
  hls = {},
  jdtls = {
    -- fall back to the file's directory when there's no project root, so jdtls
    -- treats standalone files as an invisible project instead of syntax-only
    root_dir = function(bufnr, on_dir)
      local markers = require('java-core.ls.servers.jdtls.root').get_root_markers()
      on_dir(vim.fs.root(bufnr, markers) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
    end,
  },
  tinymist = {},
  racket_langserver = {}
}

for server, config in pairs(servers) do
  if not vim.tbl_isempty(config) then
    vim.lsp.config(server, config)
  end
end

vim.lsp.enable(vim.tbl_keys(servers))
