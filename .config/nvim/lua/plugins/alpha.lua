return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- Set the header
        dashboard.section.header.val = {
           " @@@  @@@  @@@@@@@@   @@@@@@   @@@  @@@  @@@  @@@@@@@@@@",   
           " @@@@ @@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@  @@@@@@@@@@@",  
           " @@!@!@@@  @@!       @@!  @@@  @@!  @@@  @@!  @@! @@! @@!",  
           " !@!!@!@!  !@!       !@!  @!@  !@!  @!@  !@!  !@! !@! !@!",  
           " @!@ !!@!  @!!!:!    @!@  !@!  @!@  !@!  !!@  @!! !!@ @!@",  
           " !@!  !!!  !!!!!:    !@!  !!!  !@!  !!!  !!!  !@!   ! !@!",  
           " !!:  !!!  !!:       !!:  !!!  :!:  !!:  !!:  !!:     !!:",  
           " :!:  !:!  :!:       :!:  !:!   ::!!:!   :!:  :!:     :!:",  
           " ::   ::   :: ::::  ::::: ::    ::::     ::  :::     ::",   
           " ::    :   : :: ::    : :  :      :      :     :      :",    
            "[ @hologramkrypt ]",
        }
        -- Set footer
        dashboard.section.footer.val = "Welcome back, shade!"
        -- Setup alpha
        alpha.setup(dashboard.config)

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end
}
