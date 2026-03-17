return {

    { "folke/which-key.nvim", lazy = true },
   
    { "nvim-neorg/neorg",
    ft = "norg", 
    opts = {
      load = {["core.defaults"] = {}, },
      },
     },

    { "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

    { "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
    end,
  },

    { "nvim-tree/nvim-web-devicons", lazy = true },
    
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    { "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
     },

    { "monaqa/dial.nvim",
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
     },

    { "BurntSushi/ripgrep" }
}
