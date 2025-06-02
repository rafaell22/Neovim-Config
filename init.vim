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

" View md files
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" for Prettier
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
 	\ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

" vim-unimpaired - keymappings for navigation
Plug 'tpope/vim-unimpaired'

" nvim-telescope dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

Plug 'github/copilot.vim'

" List ends here. Plugins become visible to VIM after this call.
call plug#end()

nnoremap <leader>cd :lcd %:h<CR>

lua require('config')

nnoremap <silent> <leader>nhl :nohlsearch<CR>
nnoremap <silent> <leader>j :CocCommand formatJson<CR>

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Accept coc suggestions
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" set editor env variables
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set fillchars+=vert:│
set number
set relativenumber
set clipboard=unnamed
set fileformats=unix,dos

" highlight VertSplit guibg=Orange guifg=Black ctermbg=6 ctermfg=0
highlight VertSplit ctermbg=NONE guibg=NONE

filetype plugin on

" configure Taboo for tabs
set sessionoptions+=tabpages,globals

" configure quickfix to open in a new tab
noremap <leader>qf :copen<CR>:tab split<CR>:TabooRename Quickfix<CR>

" configure quickfix to open files in a new tab or focus an existing tab if the file is already open
:set switchbuf+=usetab,newtab
" autocmd FileType qf nnoremap <buffer> <Enter> " <C-W><Enter><C-W>T

" refresh/update quickfix results after changes
command! -nargs=0 -bar QFRefresh execute get(getqflist({'title':1}), 'title')

" shortcuts for normal mode, work with tabs
noremap <C-t> <Esc>:tabnew<CR>
noremap <C-F4> <Esc>:tabclose<CR>

" paste buffer content when in insert mode
inoremap <C-v> <Esc>pbi

" copy v-mode selected content to windows clipboard
noremap <C-c> "*y

" paste from windows buffer
noremap <C-v> "*p

" select all content in file
noremap <leader>all ggVG

" inverse tab with Shift + Tab
" normal tab with Tab
" for normal mode
nnoremap <S-Tab> <<
nnoremap <Tab> >>
" for insert mode
inoremap <S-Tab> <C-d>
" for visual mode
vnoremap <S-Tab> <<
vnoremap <Tab> >

" add semi-colon at the end of the current line
nnoremap <leader>; <End>a;<Esc>

" add new line ahead of cursor position
nnoremap <leader><CR> a<CR><Up><End><CR>

" enter virtual mode and select everything from cursor forward
inoremap <S-End> <Esc>v$
nnoremap <S-End> <Esc>v$

" undo change in insert mode
inoremap <C-z> <Esc>ui
nnoremap <C-z> u
nnoremap <C-S-z> <C-r>

" toggle nerd tree
nnoremap <leader>tt :NvimTreeToggle<CR>

" shortcuts for decoding/encoding HTML
:cabbr hencode :call HTMLEncode()
:cabbr hdecode :call HTMLDecode()

" switch between split windows
nnoremap <c-Left> <c-w><Left>
nnoremap <c-Up> <c-w><Up>
nnoremap <c-Right> <c-w><Right>
nnoremap <c-Down> <c-w><Down>

" prettier
"let g:prettier#autoformat = 0
" let g:prettier#autoformat_require_pragma = 0

" when running at every change you may want to disable quickfix
" let g:prettier#quickfix_enabled = 0

" navigate coc errors
nmap <silent> <Leader>j <Plug>(coc-diagnostic-next-error)
nmap <silent> <Leader>k <Plug>(coc-diagnostic-prev-error)

" configs for MarkdownPreview
" auto start preview when opening file
let g:mkdp_auto_start = 1
" only refresh preview when saving the buffer or leaving insert mode
let g:mkdp_refresh_slow = 1

" configs for telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fs <cmd>Telescope grep_string<cr>
nnoremap <leader>gd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>
