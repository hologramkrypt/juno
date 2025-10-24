-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" },
        { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope.nvim" },
        { "mbbill/undotree" },
        { "mason-org/mason.nvim" },
        { "tpope/vim-fugitive" },
        { "habamax/vim-habamax" },
        { "fxn/vim-monochrome"},
        {
            "vague-theme/vague.nvim",
            lazy = false,      -- make sure we load this during startup if it is your main colorscheme
            priority = 1000,   -- make sure to load this before all the other plugins
            config = function()
                -- NOTE: you do not need to call setup if you don't want to.
                require("vague").setup({
                    -- optional configuration here
                })
                vim.cmd("colorscheme vague")
            end
        },
        { "projekt0n/github-nvim-theme" },
        { "nyoom-engineering/oxocarbon.nvim" },
        { "habamax/vim-habamax" },
        { "theprimeagen/harpoon" },
        { "theprimeagen/vim-be-good" },
        {
            'AlexvZyl/nordic.nvim',
            lazy = false,
            priority = 1000,
            config = function()
            end
        },
        { "ramojus/mellifluous.nvim", },
        { "folke/tokyonight.nvim",    lazy = false },
        {
            "startup-nvim/startup.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
            config = function()
                require "startup".setup({ theme = "dashboard" })
            end
        },
    },

    checker = { enabled = true },

})
