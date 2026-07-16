-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovim runs on Windows here, so sqlite.lua (used by telescope-smart-history)
-- needs a Windows sqlite3.dll. Ship a dedicated one in the config dir so it
-- doesn't depend on other software being installed.
vim.g.sqlite_clib_path = vim.fn.stdpath('config') .. '/sqlite3.dll'

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

	-- Ctrl+F: search/filter files by name, recursing into subfolders.
	-- expand_all loads nested children first so the filter can match them,
	-- and folders leading to a match stay open. Esc Esc leaves the search.
	vim.keymap.set('n', '<C-f>', function()
		api.tree.expand_all()
		api.live_filter.start()
	end, opts('Filter (search by name, recursive)'))
	vim.keymap.set('n', '<Esc><Esc>', function()
		api.live_filter.clear()
		api.tree.collapse_all()
	end, opts('Clear Filter'))

	-- w: toggle tree width to fit the longest visible name, and back to default.
	local default_width = 30
	vim.keymap.set('n', 'w', function()
		local win = vim.api.nvim_get_current_win()
		if vim.api.nvim_win_get_width(win) > default_width then
			pcall(vim.cmd, 'vertical resize ' .. default_width)
		else
			local max = default_width
			for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
				max = math.max(max, vim.fn.strdisplaywidth(line))
			end
			pcall(vim.cmd, 'vertical resize ' .. (max + 2))
		end
	end, opts('Toggle width to fit names'))
end

-- empty setup using defaults
require('nvim-tree').setup({
	-- auto_close = true,
	on_attach = on_attach,
  sort_by = 'case_sensitive',
	open_on_tab = true,
	hijack_cursor = true,
	-- Reveal/highlight the active file in the tree when it changes,
	-- e.g. after opening a file from Telescope find_files.
	update_focused_file = {
		enable = true,
		update_root = false,
	},
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
	live_filter = {
		prefix = '[FILTER]: ',
		always_show_folders = false,
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
local telescope_actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git/', 'dist/', 'build/' },
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_width = 0.55,
      },
    },
    -- Context-aware prompt history via telescope-smart-history: each query is
    -- remembered per picker + cwd, so Ctrl+Up/Ctrl+Down cycle the searches
    -- relevant to the current finder and project (like "/" history).
    -- Plain Up/Down still navigate the results list.
    history = {
      path = vim.fn.stdpath('data') .. '/databases/telescope_history.sqlite3',
      limit = 100,
    },
    mappings = {
      i = {
        ['<C-Up>'] = telescope_actions.cycle_history_prev,
        ['<C-Down>'] = telescope_actions.cycle_history_next,
      },
      n = {
        ['<C-Up>'] = telescope_actions.cycle_history_prev,
        ['<C-Down>'] = telescope_actions.cycle_history_next,
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

-- Ensure the directory for the smart-history sqlite database exists
vim.fn.mkdir(vim.fn.stdpath('data') .. '/databases', 'p')

-- Load telescope extensions
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'smart_history')

-- ==============================================================================
-- KIRO CLI CONFIGURATION
-- ==============================================================================
-- Open Kiro CLI in a horizontal split
vim.keymap.set("n", "<leader>ki", function()
	vim.cmd("botright split")
	vim.cmd("resize 20")
	vim.cmd("terminal")
	vim.fn.chansend(vim.b.terminal_job_id, "kiro-cli\n")
	vim.cmd("startinsert")
end, { desc = "Open Kiro CLI" })

-- Escape terminal mode back to normal mode
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
