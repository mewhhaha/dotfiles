
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true



return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
			vim.keymap.set("n", "<leader>b", "<cmd>NvimTreeToggle<cr>", {
				desc = "Open file tree",
			})
		end,
	},
}
