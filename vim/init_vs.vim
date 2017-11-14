set nocompatible

" Don't create a backup file, don't autosave session
set nobackup
let g:session_autosave = 'no'

" Set highlighted, incremental search
set hlsearch incsearch

" Set tab behavior to always use/expect 4 spaces
set tabstop=4 shiftwidth=4 smarttab expandtab autoindent

" Set CTRL-A and CTRL-X to only work on decimal, binary, and hex numbers
set nrformats=bin,hex

" Set key timeout length to 700 milliseconds
set timeoutlen=700

" Set leader to space
let mapleader = " "
noremap <space> <NOP>

" Break bad habits
noremap <Up>       <NOP>
noremap <Down>     <NOP>
noremap <Left>     <NOP>
noremap <Right>    <NOP>
noremap <PageUp>   <NOP>
noremap <PageDown> <NOP>
noremap <Home>     <NOP>
noremap <End>      <NOP>

" Buffer movement
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Make Y work like C and D
nnoremap Y y$

" Use <leader>w for saving
nnoremap <leader>w :vsc File.SaveSelectedItems<CR>
vnoremap <leader>w <C-C>:vsc File.SaveSelectedItems<CR>

" Use <leader>8  and <C-v> for pasting from the clipboard
nnoremap <leader>8 "*p
vnoremap <leader>8 "*p

" Use <leader>f for find in files
noremap <leader>f :vsc Edit.FindinFiles<CR>

" Use vim-style indent rules
set novsvim_useeditorindent

" Make gu and gU work
vnoremap gU :vsc Edit.MakeUppercase<CR>
vnoremap gu :vsc Edit.MakeLowercase<CR>

" Make gf work
noremap  gf :vsc Edit.OpenFile<CR>

" Use <leader>p for fuzzy searching
noremap <leader>p :vsc Edit.NavigateTo<CR>

" Make gd work (CTRL-] is mapped to "go to definition"
" in Visual Studio
nnoremap gd <C-]>
