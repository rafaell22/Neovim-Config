" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-pairs', 'coc-haxe']  " list of CoC extensions needed

" switching to coc-pairs
" Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

" icons to show in file tree
Plug 'nvim-tree/nvim-web-devicons' "icons for file tree

" file tree
Plug 'nvim-tree/nvim-tree.lua'

" file content minimap
Plug 'wfxr/minimap.vim'

" Bottom status bar
Plug 'vim-airline/vim-airline'

" Git functions
Plug 'tpope/vim-fugitive'

" comment code
Plug 'preservim/nerdcommenter'

" Syntax highlight
Plug 'sheerun/vim-polyglot'

" util functions for tabs (ex. renaming)
Plug 'gcmt/taboo.vim'

" for custom comment blocks
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-tree-docs'

" Github Copilot entities
Plug 'github/copilot.vim'

" View md files
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" List ends here. Plugins become visible to VIM after this call.
call plug#end()

" Fix issue with using bash instead of cmd as default shell
let $TMP="/tmp"

nnoremap <leader>cd :lcd %:h<CR>

lua require('config')

" configure minimap
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
let g:minimap_highlight_range = 1
let g:minimap_highlight_search = 1
let g:minimap_git_colors = 1

nnoremap <silent> <leader>nhl :nohlsearch<CR>:call minimap#vim#ClearColorSearch()<CR>
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
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
set fillchars+=vert:│
set number
set relativenumber

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
inoremap <C-p> <Esc>pbi

" copy v-mode selected content to windows clipboard
noremap <leader>c "*y

" paste from windows buffer
noremap <leader>p "*p

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
nnoremap ; <End>a;<Esc>

" enter virtual mode and select everything from cursor forward
inoremap <S-End> <Esc>v$
nnoremap <S-End> <Esc>v$

" undo change in insert mode
inoremap <C-z> <Esc>ui

" toggle nerd tree
nnoremap <leader>tt :NvimTreeToggle<CR>

" shortcuts for decoding/encoding HTML
:cabbr hencode :call HTMLEncode()
:cabbr hdecode :call HTMLDecode()

nnoremap <leader>md :MarkdownPreviewToggle<CR>
