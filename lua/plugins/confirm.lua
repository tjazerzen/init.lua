return { -- autoformat
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[f]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- disable "format_on_save lsp_fallback" for languages that don't have a well standardized coding style.
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 2000,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		format_notify = function(success, errors)
			if not success then
				vim.notify("Formatting failed: " .. errors[1], vim.log.levels.ERROR)
			else
				vim.notify("Formatted", vim.log.levels.INFO)
			end
		end,

		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier", "rustywind" },
			typescript = { "prettier", "rustywind" },
			javascriptreact = { "prettier", "rustywind" },
			typescriptreact = { "prettier", "rustywind" },
			html = { "djlint", "rustywind" },
			css = { "prettier" },
			cs = { "csharpier" },
			scss = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			python = { "black", "isort" },
			sh = { "shfmt" },
		},
	},
}
