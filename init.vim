let mapleader=" "

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'

" Declare the list of plugins.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_global_extensions = ['coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-format-json', 'coc-pairs']  " list of CoC extensions needed

" icons to show in file tree
Plug 'nvim-tree/nvim-web-devicons' "icons for file tree

" file tree
Plug 'nvim-tree/nvim-tree.lua'

" Bottom status bar
Plug 'nvim-lualine/lualine.nvim'

" comment code
Plug 'preservim/nerdcommenter'

" Syntax highlight
Plug 'sheerun/vim-polyglot'

" for syntax highlight
Plug 'nvim-treesitter/nvim-treesitter'
let mapleader=" "

" ==============================================================================
" PLUGINS
" ==============================================================================
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" LSP and completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" File explorer
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" Status line
Plug 'nvim-lualine/lualine.nvim'

" Comments
Plug 'preservim/nerdcommenter'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" Code formatter
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

" Navigation helpers
Plug 'tpope/vim-unimpaired'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'

" AI assistance
"Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main' }

call plug#end()

" ==============================================================================
" EDITOR SETTINGS
" ==============================================================================
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab
set number
set relativenumber
set clipboard=unnamed
set fileformats=unix,dos
set fillchars+=vert:│
set sessionoptions+=tabpages,globals
set switchbuf+=usetab,newtab
set termguicolors
set updatetime=300
set signcolumn=yes

filetype plugin indent on

" ==============================================================================
" HIGHLIGHTING
" ==============================================================================
highlight VertSplit ctermbg=NONE guibg=NONE
highlight CocFloating ctermbg=darkgrey guibg=#222222
highlight CocSearch ctermfg=Red guifg=#FF0000

" ==============================================================================
" COC.NVIM CONFIGURATION
" ==============================================================================
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Tab completion with coc
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Diagnostics navigation
nmap <silent> <Leader>dn <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>dp <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>de <Plug>(coc-diagnostic-next-error)

" ==============================================================================
" KEYMAPS - FILE OPERATIONS
" ==============================================================================
nnoremap <leader>cd :lcd %:h<CR>
nnoremap <silent> <leader>nhl :nohlsearch<CR>

" ==============================================================================
" KEYMAPS - EDITING
" ==============================================================================
" Select all
nnoremap <leader>all ggVG

" Add semicolon at end
nnoremap <leader>; <End>a;<Esc>

" Add new line
nnoremap <leader><CR> a<CR><Up><End><CR>

" ==============================================================================
" KEYMAPS - INDENTATION
" ==============================================================================
" Normal mode
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" Insert mode
inoremap <S-Tab> <C-d>

" Visual mode - keep selection after indent
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" ==============================================================================
" KEYMAPS - CLIPBOARD
" ==============================================================================
inoremap <C-v> <Esc>pa
vnoremap <C-c> "*y
nnoremap <C-v> "*p

" ==============================================================================
" KEYMAPS - UNDO/REDO
" ==============================================================================
inoremap <C-z> <Esc>ui
nnoremap <C-z> u
nnoremap <C-S-z> <C-r>

" ==============================================================================
" KEYMAPS - SELECTION
" ==============================================================================
inoremap <S-End> <Esc>v$
nnoremap <S-End> v$

" ==============================================================================
" KEYMAPS - WINDOW NAVIGATION
" ==============================================================================
nnoremap <C-Left> <C-w><Left>
nnoremap <C-Up> <C-w><Up>
nnoremap <C-Right> <C-w><Right>
nnoremap <C-Down> <C-w><Down>

" ==============================================================================
" KEYMAPS - TABS
" ==============================================================================
nnoremap <C-t> :tabnew<CR>
nnoremap <C-F4> :tabclose<CR>

" ==============================================================================
" KEYMAPS - PLUGINS
" ==============================================================================
" NvimTree
nnoremap <leader>tt :NvimTreeToggle<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

" ==============================================================================
" MARKDOWN PREVIEW
" ==============================================================================
let g:mkdp_auto_start = 1
let g:mkdp_refresh_slow = 1

" ==============================================================================
" LOAD LUA CONFIGURATION
" ==============================================================================
lua require('config')
