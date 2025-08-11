require'lspconfig'.ts_ls.setup{}

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.vscode == nil then
	require'nvim-web-devicons'.get_icons()
	
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
	local nvim_tree = require('nvim-tree')
	nvim_tree.setup()
	nvim_tree.setup {
		-- auto_close = true,
		on_attach = on_attach,
		open_on_tab = true,
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
			relativenumber = true
		}
	}
	
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

end

require "nvim-treesitter.configs".setup {
	ensure_installed = { "javascript", "json", "html", "css", "lua" },
	auto_install = true,
	highlight = {
		enable = true
	}
}

require "lualine".setup {
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
}

require("CopilotChat").setup {
	window = {
		width = 0.3,
	}
}
