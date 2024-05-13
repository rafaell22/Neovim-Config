let mapleader=" "

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-pairs', 'coc-haxe']  " list of CoC extensions needed

" icons to show in file tree
if exists('g:vscode') 
else
	Plug 'nvim-tree/nvim-web-devicons' "icons for file tree
endif

" file tree
if exists('g:vscode') 
else
	Plug 'nvim-tree/nvim-tree.lua'
endif

" Bottom status bar
if exists('g:vscode') 
else
	Plug 'vim-airline/vim-airline'
endif

" Git functions
if exists('g:vscode') 
else
	Plug 'tpope/vim-fugitive'
endif

" comment code
Plug 'preservim/nerdcommenter'

" Syntax highlight
Plug 'sheerun/vim-polyglot'

" util functions for tabs (ex. renaming)
if exists('g:vscode') 
else
	Plug 'gcmt/taboo.vim'
end

" for custom comment blocks
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-tree-docs'

" View md files
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" ctags - Todo: Learn how to use it and then re-install
" Plug 'ludovicchabant/vim-gutentags'

" ripgrep (text search)
Plug 'jremmen/vim-ripgrep'

" for Prettier
if exists('g:vscode') 
else
	" post install (yarn install | npm install) then load plugin only for editing supported files
	Plug 'prettier/vim-prettier', {
	  \ 'do': 'yarn install --frozen-lockfile --production',
	  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
end

" vim-unimpaired - keymappings for navigation
Plug 'tpope/vim-unimpaired'

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

nnoremap <leader>md :MarkdownPreviewToggle<CR>

" switch between split windows
nnoremap <c-Left> <c-w><Left>
nnoremap <c-Up> <c-w><Up>
nnoremap <c-Right> <c-w><Right>
nnoremap <c-Down> <c-w><Down>

" prettier
let g:prettier#autoformat = 0
let g:prettier#autoformat_require_pragma = 0

" when running at every change you may want to disable quickfix
let g:prettier#quickfix_enabled = 0

" navigate coc errors
nmap <silent> <Leader>j <Plug>(coc-diagnostic-next-error)
nmap <silent> <Leader>k <Plug>(coc-diagnostic-prev-error)