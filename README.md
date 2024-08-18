# init.lua

My neovim config.

Support for the following functionality:
- vim keybindings
- fuzzy finding for grepping, files, and more
- git support: see branch, gitblame
- code assistant support. I use [supermaven](https://supermaven.com/).
- editing folders as a regular buffer
- viewing markdown files
- debugging (at the moment, only Go files)
- language server support
- search and replace across entire repository

## Requirements

- [ripgrep](https://github.com/BurntSushi/ripgrep)

## Installation

1. Backup your previous configuration (if it exists)
2. Run
   ```sh
   git clone https://github.com/tjazerzen/init.lua.git ~./config/nvim
   ```
