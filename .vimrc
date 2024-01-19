set scrolloff=7
syntax enable
filetype indent on
set number
set modeline

" Change color schema because the default is hard to read in tmux
colorscheme dark_matter

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk
map 0 g0
map $ g$

" Show break line indecator
set showbreak=@

" Ignore case when searching
set ignorecase
