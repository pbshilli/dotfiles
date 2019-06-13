set nocompatible

" Disable regular modelines in favor of secure modelines
set nomodeline

" Load plugins
call plug#begin("~/vimfiles/plugged")

" Fuzzy file search
Plug 'kien/ctrlp.vim'

" Language server protocol
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" Color schemes
Plug 'romainl/Apprentice'

" File explorer
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-dispatch'

" CTAGS utility
Plug 'ludovicchabant/vim-gutentags'

" GVIM font zooming
Plug 'thinca/vim-fontzoom'

" Grep utility
Plug 'mhinz/vim-grepper'

" Syntax highlighting
Plug 'kergoth/vim-bitbake'
if has('win32')
    Plug 'm42e/trace32-practice.vim'
endif

" Secure modelines
Plug 'ciaranm/securemodelines'

call plug#end()

" Don't create a backup file, don't autosave session
set nobackup
let g:session_autosave = 'no'

" Set up GVIM
if has("gui_running")
    " Set the GUI font
    set guifont=Consolas:h10

    " Set up the Apprentice color scheme
    colorscheme apprentice

    " Remove menu bar, toolbar, and scroll bars
    set guioptions-=m
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r

    " Set default window size
    set lines=50 columns=115

" Set up terminal VIM in ComEmu
elseif !empty($CONEMUBUILD)
    set term=xterm-256color
    set t_Co=256
endif

" Set up Vim for all 256-color terminals
if $TERM =~ "-256color"
    colorscheme apprentice
endif

" Enable syntax highlighting
syntax enable

" File autocommands
filetype plugin on 

" Always show the status bar
set laststatus=2

" Make the current line and relative numbers visible
set number relativenumber

" When scrolling, always show 5 lines of context
set scrolloff=5

" Make cursor position and partial commmands visible
set ruler showcmd

" Set highlighted, incremental search
set hlsearch incsearch

" Show all possible matches while using tab completion
set wildmode=list:full

" Disable word line wrapping
set nowrap

" If line wrapping is enabled, however, set up line breaks at word boundaries,
" and indent the broken line (if breakindent is supported)
set linebreak
silent! set breakindent breakindentopt=shift:4

" Set tab behavior to always use/expect 4 spaces
set tabstop=4 shiftwidth=4 smarttab expandtab autoindent

" Set CTRL-A and CTRL-X to only work on decimal, hex, and binary (if supported) numbers
set nrformats=hex
silent! set nrformats+=bin

" Set key timeout length to 700 milliseconds
set timeoutlen=700

" Disable terminal escape sequence timeouts
set ttimeoutlen=0

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

" Use <leader>bd to delete a buffer without closing the
" window
nnoremap <silent> <leader>bd :bp\|bd #<CR>

" Use CTRL-N, CTRL-P to cyle through grep results
nnoremap <silent> <C-N> :update<CR>:cn<CR>zv
nnoremap <silent> <C-P> :update<CR>:cp<CR>zv

" Use <leader>w for saving
nnoremap <leader>w :update<CR>
vnoremap <leader>w <C-C>:update<CR>

" Use <leader>8  and <C-v> for pasting from the clipboard
nnoremap <leader>8 "*p
vnoremap <leader>8 "*p
inoremap <C-v> <C-R>*

" Set whitespace characters
set listchars=tab:»·,trail:·,eol:$

" Grepper
set grepprg=grep\ -ErInH

let g:grepper = {
    \ 'tools': ['grep'],
    \ 'grep': {
    \   'grepprg':    'grep -EInr',
    \   'grepprgbuf': 'grep -EInH $* $+',
    \   'grepformat': '%f:%l:%m' }}

nnoremap <leader>f :Grepper -noswitch -cword<CR>
nnoremap <leader>/ :Grepper-buffer -noswitch -cword<CR>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" By default, disable gutentags and remove all project root detection since it
" doesn't play nicely with submodules
let g:gutentags_enabled = 0
let g:gutentags_add_default_project_roots = 0
let g:gutentags_add_ctrlp_root_markers = 0

" Ctrl-P
let g:ctrlp_map = '<leader>p'

" Set Ctrl-P to always use the working directory
let g:ctrlp_working_path_mode = '0'

" Don't limit Ctrl-P files
let g:ctrlp_max_files = 0

" Language Server
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

autocmd FileType python setlocal omnifunc=lsp#complete
autocmd FileType python nnoremap gd :LspDefinition<cr>
autocmd FileType python nnoremap K :LspHover<cr>
autocmd FileType python nnoremap <leader>r :LspReferences<cr>

" Remap some things for omnicomplete goodness
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

" If a session is loaded and specifies g:prj_path, set up
" grepper and gutentags accordingly
function SetupPrjPath()
    if exists('g:prj_path')
        let g:grepper.grep.grepprg = 'grep -EInr $* ' . g:prj_path
        if len(g:gutentags_project_root) > 0
            if has('win32')
                let g:gutentags_file_list_command = 'dir ' . g:prj_path . ' /-n /b /s /a-d'
            else
                let g:gutentags_file_list_command = 'find ' . g:prj_path . ' -type f'
            endif
            let g:gutentags_enabled = 1
            GutentagsUpdate!
        endif
    endif
endfunction
autocmd SessionLoadPost * call SetupPrjPath()
