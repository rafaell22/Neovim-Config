require'nvim-web-devicons'.get_icons()

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
local nvim_tree = require('nvim-tree')
nvim_tree.setup()
nvim_tree.setup {
	-- auto_close = true,
	open_on_setup = true,
	open_on_tab = true,
	-- Creating a file when the cursor is on a closed folder will set the path to be inside the closed folder
	create_in_closed_folder = true,
	hijack_cursor = true,
	git = {
		enable = true
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true
			}
		}
	},
	view = {
		mappings = {
			list = {
				{ key = "<C-h>", action = "split" },
				{ key = "<C-x>", action = "vsplit" }
			}
		}
	}
}

require "nvim-treesitter.configs".setup {
  tree_docs = {
    enable = true,
	keymaps = {
		doc_node_at_cursor = "z",
		doc_all_in_range = "z",
	},
    spec_config = {
      jsdoc = {
        slots = {
          class = {author = true}
        },
		templates = {
          class = {
            "doc-start",
            "author",
            "doc-end",
            "%content%",
          }
        }
      }
    }
  }
}