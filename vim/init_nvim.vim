" Disable regular modelines in favor of secure modelines
set nomodeline

" Load plugins
call plug#begin("~/AppData/Local/nvim/plugged")

" Fuzzy file search
Plug 'kien/ctrlp.vim'

" Language server
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'powershell -File install.ps1',
    \ }

" Color schemes
Plug 'romainl/Apprentice'

" File explorer
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-dispatch'

" CTAGS utility
Plug 'ludovicchabant/vim-gutentags'

" Grep utility
Plug 'mhinz/vim-grepper'

" Syntax highlighting
Plug 'kergoth/vim-bitbake'

" Secure modelines
Plug 'ciaranm/securemodelines'

call plug#end()

colorscheme apprentice

" File autocommands
filetype plugin on 

" Make the current line and relative numbers visible
set number relativenumber
"
" When scrolling, always show 5 lines of context
set scrolloff=5

" Show all possible matches while using tab completion
set wildmode=list:full

" Disable word line wrapping
set nowrap

" If line wrapping is enabled, however, set up line breaks at word boundaries,
" and indent the broken line
set linebreak
set breakindent breakindentopt=shift:4

" Set tab behavior to always use/expect 4 spaces
set tabstop=4 shiftwidth=4 expandtab

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
let g:LanguageClient_serverCommands = {
    \ 'python': ['py', '-3', '-m', 'pyls'],
    \ }

autocmd FileType python nnoremap gd :call LanguageClient#textDocument_definition()<cr>
autocmd FileType python nnoremap K :call LanguageClient#textDocument_hover()<cr>

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
