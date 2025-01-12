return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
			  keymaps = {
			    accept_suggestion = "<Tab>",
			    clear_suggestion = "<C-]>",
			    accept_word = "<C-j>",
			  }
			})
		end
	}
}

-- return {
-- 	{
-- 		"milanglacier/minuet-ai.nvim",
-- 		config = function()
-- 			require("minuet").setup({
-- 				virtualtext = {
-- 					auto_trigger_ft = {
-- 						"typescript",
-- 						"javascript",
-- 						"typescriptreact",
-- 						"javascriptreact",
-- 						"python",
-- 						"lua",
-- 						"rust",
-- 						"zig",
-- 					},
-- 					keymap = {
-- 						accept = "<A-A>",
-- 						accept_line = "<A-a>",
-- 						-- Cycle to prev completion item, or manually invoke completion
-- 						prev = "<A-[>",
-- 						-- Cycle to next completion item, or manually invoke completion
-- 						next = "<A-]>",
-- 						dismiss = "<A-e>",
-- 					},
-- 				},
-- 				provider = "claude",
-- 				provider_options = {
-- 					claude = {
-- 						max_tokens = 512,
-- 						model = "claude-3-5-haiku-latest",
-- 						api_key = "ANTHROPIC_API_KEY",
-- 						-- few_shots = "see [System Prompt] section for the default value",
-- 						stream = true,
-- 						optional = {
-- 							-- pass any additional parameters you want to send to claude request,
-- 							-- e.g.
-- 							-- stop_sequences = nil,
-- 						},
-- 					},
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	{ "nvim-lua/plenary.nvim" },
-- }
