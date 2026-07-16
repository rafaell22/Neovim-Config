-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require'nvim-web-devicons'.get_icons()

-- ==============================================================================
-- NVIM-TREE CONFIGURATION
-- ==============================================================================
-- Automatically open file on creation
local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.FileCreated, function(file)
	vim.cmd("edit " .. file.fname)
end)

local function on_attach(bufnr)
	local function opts(desc)
	return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- BEGIN_DEFAULT_ON_ATTACH
	vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
	vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
	vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
	vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
	vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
	vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
	vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
	vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
	vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
	vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
	vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
	vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
	vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
	vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
	vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
	vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
	vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
	vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
	-- END_DEFAULT_ON_ATTACH

	-- Mappings migrated from view.mappings.list
	--
	-- You will need to insert "your code goes here" for any mappings with a custom action_cb
	vim.keymap.set('n', '<C-h>', api.node.open.horizontal, opts('Open: Horizontal Split'))
	vim.keymap.set('n', '<C-x>', api.node.open.vertical, opts('Open: Vertical Split'))
end

-- empty setup using defaults
require('nvim-tree').setup({
	-- auto_close = true,
	on_attach = on_attach,
  sort_by = 'case_sensitive',
	open_on_tab = true,
	hijack_cursor = true,
	git = {
		enable = true,
    ignore = false
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
        file = true,
        folder = true,
        folder_arrow = true,
			}
		}
	},
  filters = {
    dotfiles = false,
  },
	view = {
		relativenumber = true,
		width = 30,
	}
})

local function open_nvim_tree(data)
-- buffer is a [No Name]
local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

-- buffer is a directory
local directory = vim.fn.isdirectory(data.file) == 1

if not no_name and not directory then
return
end

-- change to the directory
if directory then
vim.cmd.cd(data.file)
end

-- open the tree
require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- ==============================================================================
-- TREESITTER CONFIGURATION
-- ==============================================================================
require('nvim-treesitter.config').setup({
  ensure_installed = {
    'lua',
    'vim',
    'vimdoc',
    'javascript',
    'typescript',
    'html',
    'css',
    'json',
    'markdown',
    'markdown_inline',
    'python',
    'bash',
	},
	auto_install = true,
	highlight = {
		enable = true
	},
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<TAB>',
      node_decremental = '<S-CR>',
    },
  },
})

-- ==============================================================================
-- LUALINE CONFIGURATION
-- ==============================================================================
require('lualine').setup({
	options = {
		theme = "ayu_mirage"
	},
	sections = {
		lualine_a = {"mode"},
		lualine_b = {"branch"},
		lualine_c = {
			{
				"filename",
				file_status = true,
				path = 1
			}
		},
		lualine_x = {"location"},
		lualine_y = {"progress"},
		lualine_z = {"searchcount"}
	}
})

-- ==============================================================================
-- TELESCOPE CONFIGURATION
-- ==============================================================================
require('telescope').setup({
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git/', 'dist/', 'build/' },
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_width = 0.55,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})

-- Load telescope extensions
pcall(require('telescope').load_extension, 'fzf')
