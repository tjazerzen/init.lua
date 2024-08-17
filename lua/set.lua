-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.o.wrap = false

-- Enable mouse mode, can be useful for resizing splits for example
vim.opt.mouse = "a"
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- Remove this option if you want your OS clipboard to remain independent.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- set fold settings
-- These options are recomended by nvim-ufo
-- https://github.com/kevinhwang91/nvim-ufo --> minimal configuration
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- place a column line
vim.opt.colorcolumn = "120"

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
