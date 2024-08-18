-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Language specific debuggers
		"leoluz/nvim-dap-go",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- debug UI
		"rcarriga/nvim-dap-ui",

		-- virtual text and variable previews
		"theHamsta/nvim-dap-virtual-text",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- dap-go setup
		require("dap-go").setup()

		-- mason-nvim-dap setup
		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})

		-- dapui setup
		-- For more information, see |:help nvim-dap-ui|
		-- imported from https://github.com/rcarriga/nvim-dap-ui/blob/master/lua/dapui/config/init.lua#L79-L146
		dapui.setup({
			icons = { expanded = "", collapsed = "", current_frame = "" },
			mappings = {
				-- Use a table to apply multiple mappings
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			element_mappings = {},
			expand_lines = vim.fn.has("nvim-0.7") == 1,
			force_buffers = true,
			layouts = {
				{
					-- You can change the order of elements in the sidebar
					elements = {
						-- Provide IDs as strings or tables with "id" and "size" keys
						{
							id = "scopes",
							size = 0.25, -- Can be float or integer > 1
						},
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left", -- Can be "left" or "right"
				},
				{
					elements = {
						"repl",
						"console",
					},
					size = 10,
					position = "bottom", -- Can be "bottom" or "top"
				},
			},
			floating = {
				max_height = nil,
				max_width = nil,
				border = "single",
				mappings = {
					["close"] = { "q", "<Esc>" },
				},
			},
			controls = {
				enabled = vim.fn.exists("+winbar") == 1,
				element = "repl",
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			render = {
				max_type_length = nil, -- Can be integer or nil.
				max_value_lines = 100, -- Can be integer or nil.
				indent = 1,
			},
		})

		-- nvim-dap-virtual-text setup
		require("nvim-dap-virtual-text").setup({
			enabled = true,
		})

		-- NOTE: we didn't setup nvim-nio here

		-- Keymaps setup

		-- DEBUGGING KEYMAPS: for managing breakpoints
		vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Debug: Step Back" })
		vim.keymap.set("n", "<F12>", dap.restart, { desc = "Debug: Restart" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })
		-- Eval var under cursor
		vim.keymap.set("n", "<space>?", function()
			require("dapui").eval(nil, { enter = true, context = "hover", width = 100, height = 20 })
		end, { desc = "Debug: Evaluate variable under cursor" })
		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

		-- DEBUGGING KEYMAPS: for entering and exiting debug modes
		-- Toggle Debug Console (REPL)
		vim.keymap.set("n", "<leader>dt", function()
			require("dap").repl.toggle({ height = 15 })
		end, { desc = "Debug: Toggle REPL" })
		-- Reopen All Debugger Panes
		vim.keymap.set("n", "<leader>do", function()
			require("dapui").open()
		end, { desc = "Debug: Reopen All Panes" })
		-- Close All Debugger Panes
		vim.keymap.set("n", "<leader>dc", function()
			require("dapui").close()
		end, { desc = "Debug: Close All Panes" })

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
