return {
	{
		"scalameta/nvim-metals",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		ft = { "scala", "sbt" },
		config = function()
			local metals = require("metals")
			local metals_config = metals.bare_config()

			metals_config.settings = {
				showImplicitArguments = true,
				excludedPackages = { "akka.actor.typed.javadsl" },
			}

			metals_config.init_options = {
				statusBarProvider = "on",
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "scala", "sbt" },
				callback = function()
					metals.initialize_or_attach(metals_config)
				end,
			})
		end,
	},
}
