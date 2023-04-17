" Disable regular modelines in favor of secure modelines
set nomodeline

" Load plugins
if has("win32")
    call plug#begin("~/AppData/Local/nvim/plugged")
else
    call plug#begin("~/.config/nvim/plugged")
endif

" Fuzzy file search
Plug 'kien/ctrlp.vim'

" Color schemes
Plug 'romainl/Apprentice'

" File explorer
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-dispatch'

" CTAGS utility
Plug 'ludovicchabant/vim-gutentags'

" Syntax highlighting
Plug 'kergoth/vim-bitbake'

" Secure modelines
Plug 'ciaranm/securemodelines'

call plug#end()

colorscheme apprentice

" File autocommands
filetype plugin on 

" Enable mouse support
set mouse=a

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

" grep
set grepprg=ag\ --vimgrep

" Ignore CRLFs
if has("win32")
    set grepformat=%f:%l:%c:%m%*[\\r],
else
    set grepformat=
endif

set grepformat+=%f:%l:%c:%m

let g:prj_path = ''
nnoremap <leader>f :sil :gr! "\b<C-R>=expand("<cword>")<CR>\b" <C-R>=g:prj_path<CR> \| copen<C-B><C-Right><C-Right><C-Right><Left><Left><Left>

" By default, disable gutentags and remove all project root detection since it
" doesn't play nicely with submodules
let g:gutentags_enabled = 0
let g:gutentags_add_default_project_roots = 0
let g:gutentags_add_ctrlp_root_markers = 0
if has("win32")
    let g:gutentags_ctags_executable = '~/prj/ctags/ctags'
else
    let g:gutentags_ctags_executable = '~/git/ctags/ctags'
endif

" Ctrl-P
let g:ctrlp_map = '<leader>p'

" Set Ctrl-P to always use the working directory
let g:ctrlp_working_path_mode = '0'

" Don't limit Ctrl-P files
let g:ctrlp_max_files = 0

" Language Server
if has("win32")
    let g:LanguageClient_serverCommands = {
        \ 'python': ['py', '-3', '-m', 'pyls'],
        \ }
else
    let g:LanguageClient_serverCommands = {
        \ 'python': ['python3', '-m', 'pyls'],
        \ }
endif

lua << EOF
    local is_windows = vim.loop.os_uname().version:match 'Windows'

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            end,
        })

    if is_windows then
        pyls_cmd = {'py', '-3', '-m', 'pyls'}
    else
        pyls_cmd = {'python3', '-m', 'pyls'}
    end

    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
            client_id = vim.lsp.start({
                name = 'pyls',
                cmd = {'python3', '-m', 'pyls'},
                root_dir = vim.fn.getcwd(),
                })
            vim.lsp.buf_attach_client(0, client_id)
            end,
        })
EOF

" Remap some things for omnicomplete goodness
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-x><C-o>

" If a session is loaded and specifies g:prj_path, set up
" gutentags accordingly
function SetupPrjPath()
    if g:prj_path != ''
        if len(g:gutentags_project_root) > 0
            if has('win32')
                let g:gutentags_file_list_command = 'wsl find ' . g:prj_path . ' -type f'
            else
                let g:gutentags_file_list_command = 'find ' . g:prj_path . ' -type f'
            endif
            let g:gutentags_enabled = 1
            GutentagsUpdate!
        endif
    endif
endfunction
autocmd SessionLoadPost * call SetupPrjPath()
