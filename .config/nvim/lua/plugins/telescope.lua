return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		-- or                              , branch = '0.1.x',
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
		keys = {
			{
				"<leader>t",
				function()
					local builtin = require("telescope.builtin")
					local theme = require("telescope.themes")
					builtin.find_files(theme.get_dropdown({
						find_command = { "rg", "--files", "--glob=!.git", "-.", "--ignore" },
					}))
				end,
				desc = "Search files",
			},
		},
		config = function()
			require("telescope").setup {
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {}
					}  					
				}
			}

			require("telescope").load_extension("ui-select")
	  end,
	},
}
