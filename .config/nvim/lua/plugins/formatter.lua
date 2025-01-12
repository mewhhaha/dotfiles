return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
		keys = {
			{
				"<leader>j",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = function()
			---@class ConformOpts
			local opts = {
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 2500,
				},
				formatters_by_ft = {
					sh = { "shfmt", "trim_newlines", "trim_whitespace" },
					lua = { "stylua", "trim_newlines", "trim_whitespace" },
					javascript = { "prettierd", "trim_whitespace" },
					javascriptreact = { "prettierd", "trim_whitespace" },
					typescript = { "prettierd", "trim_newlines", "trim_whitespace" },
					html = { "prettierd", "trim_newlines", "trim_whitespace" },
					typescriptreact = { "prettierd", "trim_newlines", "trim_whitespace" },
					go = { "gofmt", "trim_newlines", "trim_whitespace" },
					markdown = { "prettierd", "trim_newlines", "trim_whitespace" },
				},
			}
			return opts
		end,
	},
}
