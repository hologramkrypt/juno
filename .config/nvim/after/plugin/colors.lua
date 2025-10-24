function ColorMyPencils(color)
	color = ""
    vim.api.nvim_set_option('background', 'dark')
    vim.cmd.colorscheme('vague')
	
	vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})

end

ColorMyPencils()


