return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { 
            "nvim-lua/plenary.nvim", 
            "nvim-telescope/telescope-file-browser.nvim" 
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        "node_modules", 
                        ".git",
                        ".cache",
                        "build",
                        "dist"
                    }
                }
            })

            telescope.load_extension("file_browser")

            vim.keymap.set('n', '<leader>ff', function()
            builtin.find_files({
                cwd = vim.fn.getcwd(),
                hidden = true
            })
        end,
        { desc = "Find files in current directory" })

        vim.keymap.set('n', '<leader>fg', builtin.live_grep)
        vim.keymap.set('n', '<leader>ps', function()
            require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
            end, {})
            vim.keymap.set('n', '<leader>fb', telescope.extensions.file_browser.file_browser, {})
        end
    }
}

