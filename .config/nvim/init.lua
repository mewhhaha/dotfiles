-- Set clipboard to use system clipboard
vim.api.nvim_set_option("clipboard", "unnamed")

-- Set leader key to space
vim.g.mapleader = "<Space>"

require("config.lazy")

-- Reserve the sign column to avoid jitter
vim.cmd("set signcolumn=yes")

-- Set relative line numbers
vim.wo.relativenumber = true

-- Saving configurations
vim.api.nvim_create_autocmd("FocusLost", {
    callback = function()
        vim.cmd("silent! w")
        vim.cmd("stopinsert")
    end
})

vim.keymap.set("n", "c", "vdi", { noremap = true })

vim.o.guifont = "FiraCode Nerd Font"

-- Autoopen file in filetree
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function() 
        vim.cmd("silent! lua require('nvim-tree.api').tree.find_file({ open = true, focus = false})")
        end
    }
)

-- Set theme to catppuccin
vim.cmd("colorscheme catppuccin")

-- Fix weird normal formatting
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smarttab = true



