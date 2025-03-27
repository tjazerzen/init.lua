--[[

To run lazy settings, run `:Lazy`

To check keybinding health and if any keys overlap with each other ->
:checkhealth which-key

Commands that will help you out a lot:
- :help -> Reading general documentation
- <leader>sh -> fuzzy finder for documentation
- <leader>sk -> fuzzy finder for keybinds
- :help X -> other help
- :checkhealth -> health check
- :help vim.opt -> setting opts
- :help 'clipboard'
- :Lazy -> check the current status of your plugins
- :help list
- :help listchars
- :help wincmd -> list of all window commands
- :help lua-guide-autocommands -> basic autocommands
- :help lazy.nvim.txt -> help on installing lazy vim
- :Lazy update -> To update plugins you can run
- :help gitsigns -> what configuration keys do

Cool keybindings I picked up:
- commenting:
  - gc2j, gc4k (comment out certain portion of lines)
  - gci{, gca{

In this config, <space> is the leader key
--]]

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
require("set")
require("remap")

-- Highlight when yanking (copying) text - Try it with `yap` in normal mode. See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.cmd([[
  autocmd BufRead,BufNewFile *.env set filetype=dotenv
]])

-- longer plugin configs are inside `lua/plugins/` directory and imported at the end of this file
-- The rest are directly utilized here
require("lazy").setup({
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"numToStr/Comment.nvim",
	{
		-- Supermaven
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				log_level = "off",
			})

			local api = require("supermaven-nvim.api")

			vim.keymap.set("n", "<leader>sm", api.toggle)
		end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-frappe")
		end,
	},
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})

			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle("diagnostics")
			end)
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufEnter",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"lazy",
					"mason",
					"notify",
					"oil",
				},
			},
		},
		main = "ibl",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"HallerPatrick/py_lsp.nvim",
	},
	-- NOTE:: 2025-03-27 - This doesn't work together with VS Code and Cursor when I import this plugin. For now, I'm just commenting it out
	-- {
	-- 	"gelguy/wilder.nvim",
	-- 	keys = {
	-- 		":",
	-- 		"/",
	-- 		"?",
	-- 	},
	-- 	dependencies = {
	-- 		"catppuccin/nvim",
	-- 	},
	-- 	config = function()
	-- 		local wilder = require("wilder")
	-- 		local macchiato = require("catppuccin.palettes").get_palette("macchiato")
	--
	-- 		-- Create a highlight group for the popup menu
	-- 		local text_highlight =
	-- 			wilder.make_hl("WilderText", { { a = 1 }, { a = 1 }, { foreground = macchiato.text } })
	-- 		local mauve_highlight =
	-- 			wilder.make_hl("WilderMauve", { { a = 1 }, { a = 1 }, { foreground = macchiato.mauve } })
	--
	-- 		-- Enable wilder when pressing :, / or ?
	-- 		wilder.setup({ modes = { ":", "/", "?" } })
	--
	-- 		-- Enable fuzzy matching for commands and buffers
	-- 		wilder.set_option("pipeline", {
	-- 			wilder.branch(
	-- 				wilder.cmdline_pipeline({
	-- 					fuzzy = 1,
	-- 				}),
	-- 				wilder.vim_search_pipeline({
	-- 					fuzzy = 1,
	-- 				})
	-- 			),
	-- 		})
	--
	-- 		wilder.set_option(
	-- 			"renderer",
	-- 			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
	-- 				highlighter = wilder.basic_highlighter(),
	-- 				highlights = {
	-- 					default = text_highlight,
	-- 					border = mauve_highlight,
	-- 					accent = mauve_highlight,
	-- 				},
	-- 				pumblend = 5,
	-- 				min_width = "100%",
	-- 				min_height = "25%",
	-- 				max_height = "25%",
	-- 				border = "rounded",
	-- 				left = { " ", wilder.popupmenu_devicons() },
	-- 				right = { " ", wilder.popupmenu_scrollbar() },
	-- 			}))
	-- 		)
	-- 	end,
	-- },
	{ import = "plugins" },
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
