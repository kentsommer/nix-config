---------------
--- General ---
---------------

-- Leader key
lvim.leader = ","

-- Code formatting
local formatters = require "lvim.lsp.null-ls.formatters"
lvim.format_on_save.enabled = true

-- Syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
  "cpp",
}

-- LSP keybindings
lvim.lsp.buffer_mappings.normal_mode['mh'] = lvim.lsp.buffer_mappings.normal_mode['K']  -- Hover
lvim.lsp.buffer_mappings.normal_mode['md'] = lvim.lsp.buffer_mappings.normal_mode['gd'] -- Definition
lvim.lsp.buffer_mappings.normal_mode['mD'] = lvim.lsp.buffer_mappings.normal_mode['gD'] -- Declaration
lvim.lsp.buffer_mappings.normal_mode['mr'] = lvim.lsp.buffer_mappings.normal_mode['gr'] -- References
lvim.lsp.buffer_mappings.normal_mode['mi'] = lvim.lsp.buffer_mappings.normal_mode['gI'] -- Implementation
lvim.lsp.buffer_mappings.normal_mode['mS'] = lvim.lsp.buffer_mappings.normal_mode['gs'] -- Signature
lvim.lsp.buffer_mappings.normal_mode['ml'] = lvim.lsp.buffer_mappings.normal_mode['gl'] -- Line diagnostics
lvim.keys.normal_mode["ms"] = "<Cmd>ClangdSwitchSourceHeader<CR>"                       -- Switch header/source

-- Disable tabs
lvim.builtin.bufferline.active = false
vim.cmd [[ set showtabline=0 ]]

-- Keybindings
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

-- Set term to fish
vim.opt.shell = "/usr/local/bin/fish"

--------------
--- Python ---
--------------

-- Black
formatters.setup { { name = "black" }, }

-- Virtual env handling
lvim.plugins = {
  {
    "AckslD/swenv.nvim",
    config = function()
      require('swenv').setup({
        get_venvs = function(venvs_path)
          return require('swenv.api').get_venvs(venvs_path)
        end,
        -- Path passed to `get_venvs`.
        venvs_path = vim.fn.expand(vim.fn.getcwd()),
        -- Something to do after setting an environment
        post_set_venv = nil,
      })
    end
  },
  "stevearc/dressing.nvim",
}
lvim.keys.normal_mode["me"] = "<cmd>lua require('swenv.api').pick_venv()<cr>"
