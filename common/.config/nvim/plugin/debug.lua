-- Debugging with nvim-dap.
--
-- Launch configurations come from `dap.configurations` below and from the
-- project's .vscode/launch.json, which nvim-dap reads on demand.

-- Also added in plugin/lsp.lua (for nvim-java), which loads after this file.
vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
}

local dap = require 'dap'
local dap_view = require 'dap-view'

-- SpecTecX: `spectecx TARGET debug TASK --dap ARGS...` serves DAP on stdio.
-- Same launch fields as the VS Code extension (editors/vscode): target, task,
-- args, cwd, plus an optional `spectecx` path to the executable. Missing
-- target/task/args are asked for here, in order (nvim-dap evaluates
-- function-valued config fields in no particular order).
local function ask(prompt, default)
  local answer = vim.fn.input(prompt, default or '')
  return answer ~= '' and answer or nil
end

-- The absolute path of an fzf-lua entry picked under `cwd`.
local function picked_path(entry, opts, cwd)
  local path = require('fzf-lua').path.entry_to_file(entry, opts).path
  return vim.fs.normalize(vim.fs.joinpath(path:sub(1, 1) == '/' and '' or cwd, path))
end

-- Calls `done(program)` with the program file picked under `cwd`.
local function pick_program(cwd, done)
  require('fzf-lua').files {
    prompt = 'Program> ',
    cwd = cwd,
    actions = {
      default = function(selected, opts)
        local program = picked_path(selected[1], opts, cwd)
        -- Let this picker close before `done` opens the next one.
        vim.schedule(function()
          done(program)
        end)
      end,
    },
  }
end

local DEFAULT_SPEC = "(the target's default)"

-- Calls `done(spec)` with the spec file picked under `cwd`, or nil for the
-- target's own spec.
local function pick_spec(cwd, done)
  require('fzf-lua').fzf_exec(("echo %q; fd -t f -e spectec"):format(DEFAULT_SPEC), {
    prompt = 'Spec> ',
    cwd = cwd,
    actions = {
      default = function(selected, opts)
        if selected[1] == DEFAULT_SPEC then
          done(nil)
        else
          done(picked_path(selected[1], opts, cwd))
        end
      end,
    },
  })
end

dap.adapters.spectec = function(callback, config)
  local cwd = config.cwd or vim.fn.getcwd()
  local command = config.spectecx
  if not command then
    local local_exe = vim.fs.joinpath(cwd, 'spectecx')
    command = vim.fn.executable(local_exe) == 1 and local_exe or 'spectecx'
  end
  local target = config.target or ask('Target: ', 'miniml')
  local task = target and (config.task or ask('Task: ', 'eval'))
  if not (target and task) then
    vim.notify('SpecTecX: debugging cancelled', vim.log.levels.WARN)
    return
  end
  local function start(extra)
    local args = { target, 'debug', task, '--dap' }
    vim.list_extend(args, extra)
    callback {
      type = 'executable',
      command = command,
      args = args,
      options = { cwd = cwd },
    }
  end
  if config.args then
    return start(config.args)
  end
  -- Closing a picker cancels the run. Breakpoints only verify against the spec
  -- actually loaded: miniml's default is the _build copy, so pick the source
  -- spec.spectec to break in it.
  pick_program(cwd, function(program)
    pick_spec(cwd, function(spec)
      start(spec and { '-p', program, '--spec', spec } or { '-p', program })
    end)
  end)
end

dap.configurations.spectec = {
  {
    type = 'spectec',
    request = 'launch',
    name = 'SpecTecX: debug a program',
    -- target, task and args are asked for by the adapter.
  },
}

-- Panels below the code, opened when a session starts and closed when it ends.
dap_view.setup {
  winbar = {
    sections = { 'scopes', 'watches', 'threads', 'breakpoints', 'exceptions', 'repl' },
    default_section = 'scopes',
    controls = {
      enabled = true,
      -- The defaults minus step_back, which spectecx doesn't support.
      buttons = { 'play', 'step_into', 'step_over', 'step_out', 'run_last', 'terminate', 'disconnect' },
    },
  },
  windows = {
    -- spectecx speaks DAP on stdio and never runs in a terminal.
    terminal = { hide = { 'spectec' } },
  },
  auto_toggle = true,
}

local map = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = 'Debug: ' .. desc })
end

map('<F5>', dap.continue, 'Start/Continue')
map('<F1>', dap.step_into, 'Step Into')
map('<F2>', dap.step_over, 'Step Over')
map('<F3>', dap.step_out, 'Step Out')
map('<leader>b', dap.toggle_breakpoint, 'Toggle Breakpoint')
map('<leader>dq', dap.terminate, 'Terminate')
map('<leader>dv', dap_view.toggle, 'Toggle Panels')
map('<leader>dh', '<cmd>DapViewHover<cr>', 'Hover Variable')
map('<leader>dw', '<cmd>DapViewWatch<cr>', 'Watch Expression')
