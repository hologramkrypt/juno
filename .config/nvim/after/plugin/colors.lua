function ColorMyPencils(color)
    color =  ""
    vim.api.nvim_set_option('background', 'dark')
    vim.cmd.colorscheme('monochrome')

    vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })

end

ColorMyPencils()
