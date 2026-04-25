" ============================================================================
" GENERAL SETTINGS
" ============================================================================
set number
set relativenumber
syntax on
set clipboard=unnamedplus

set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab             " Convert tabs to spaces (better for sharing code)

set termguicolors
set background=dark       " Optimize colors for dark terminal

" Better search behavior
set incsearch             " Highlight matches as you type
set hlsearch              " Highlight all matches
set ignorecase            " Case-insensitive search
set smartcase             " Case-sensitive if uppercase in search

" Navigation and UI improvements
set cursorline            " Highlight current line
set scrolloff=5           " Keep 5 lines visible when scrolling
set sidescroll=5          " Smooth horizontal scrolling

" Better indentation
filetype plugin indent on
set cindent
set cinoptions+=t0

" Better command mode completion
set wildmode=longest,list,full
set wildmenu              " Show menu for tab completion

" Performance
set lazyredraw            " Don't redraw during macros
set ttyfast               " Faster terminal connection

" Don't show mode (lightline/airline shows it)
set noshowmode

" ============================================================================
" LEADER KEY
" ============================================================================
let mapleader = " "       " Use spacebar as leader key
let maplocalleader = ","  " Use comma for local leader (in specific filetypes)

" ============================================================================
" CURSOR SHAPE
" ============================================================================
let &t_SI = "\e[6 q"      " Insert mode: thin blinking line
let &t_SR = "\e[4 q"      " Replace mode: blinking underscore
let &t_EI = "\e[2 q"      " Normal mode: blinking block

if has('nvim')
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
endif

" ============================================================================
" RIPGREP CONFIGURATION
" ============================================================================
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob=!tags
set grepformat=%f:%l:%c:%m

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost *grep* copen
augroup END

" ============================================================================
" PLUGINS
" ============================================================================
call plug#begin()

" Sensible defaults
Plug 'tpope/vim-sensible'

" LSP & Autocompletion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'

" Git signs
Plug 'lewis6991/gitsigns.nvim'

" Folding
Plug 'kevinhwang91/nvim-ufo'
Plug 'kevinhwang91/promise-async'

" File finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" File tree
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Themes
Plug 'folke/tokyonight.nvim'
Plug 'sainnhe/sonokai'
Plug 'ellisonleao/gruvbox.nvim'

call plug#end()

" ============================================================================
" THEME SETUP
" ============================================================================
lua << EOF
require("gruvbox").setup({
  contrast = "hard"
})
vim.cmd.colorscheme "gruvbox"
EOF

" ============================================================================
" GIT SIGNS SETUP
" ============================================================================
lua << EOF
require('gitsigns').setup()
EOF

" ============================================================================
" FOLDING SETUP
" ============================================================================
lua << EOF
require('ufo').setup()
EOF

autocmd FileType c,cpp setlocal foldmethod=syntax
autocmd FileType python setlocal foldmethod=indent
set foldlevel=99

" ============================================================================
" FILE TREE (nvim-tree) SETUP
" ============================================================================
lua << EOF
require("nvim-tree").setup({
  view = {
    width = 30,
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
})
EOF

" ============================================================================
" TELESCOPE SETUP
" ============================================================================
lua << EOF
require('telescope').setup()
EOF

" ============================================================================
" LSP SETUP - C/C++ and Python (Neovim 0.11+)
" ============================================================================
lua << EOF
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Autocompletion setup
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Configure LSP servers using vim.lsp.config
vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
})

vim.lsp.config('pylsp', {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = true },
        pyflakes = { enabled = true },
      }
    }
  }
})

-- Enable the servers
vim.lsp.enable({ 'clangd', 'pylsp' })

EOF

" ============================================================================
" KEYBINDINGS - COLUMN MARKERS
" ============================================================================
nnoremap <Leader>c :set colorcolumn=80<cr>
nnoremap <Leader>n :set colorcolumn=-80<cr>

" ============================================================================
" KEYBINDINGS - SPLIT NAVIGATION
" ============================================================================
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" ============================================================================
" KEYBINDINGS - SPLIT RESIZING
" ============================================================================
nnoremap <C-Left>  :vertical resize -2<cr>
nnoremap <C-Right> :vertical resize +2<cr>
nnoremap <C-Up>    :resize -2<cr>
nnoremap <C-Down>  :resize +2<cr>
nnoremap <Leader>f <C-w>\|<C-w>_    " Maximize current split
nnoremap <C-f> <C-w>\|<C-w>_        " Maximize current split
nnoremap <C-=> <C-w>=               " Equalize all splits
nnoremap <Leader>= <C-w>=           " Alternative equalize

" ============================================================================
" KEYBINDINGS - AUTO-COMPLETE BRACKETS AND QUOTES
" ============================================================================
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" Smart closing bracket handling
inoremap ) <c-r>=strpart(getline('.'), col('.')-1, 1) == ')' ? "\<Del>" : ')'<cr>
inoremap ] <c-r>=strpart(getline('.'), col('.')-1, 1) == ']' ? "\<Del>" : ']'<cr>
inoremap } <c-r>=strpart(getline('.'), col('.')-1, 1) == '}' ? "\<Del>" : '}'<cr>

" ============================================================================
" KEYBINDINGS - RIPGREP
" ============================================================================
nnoremap <Leader>rg :grep<Space>
nnoremap <Leader>rw :grep<Space><C-r><C-w><cr>
nnoremap <Leader>rf :grep<Space>--type<Space>

" ============================================================================
" KEYBINDINGS - LINE NUMBERS TOGGLE
" ============================================================================
nnoremap <Leader>ln :set relativenumber! set number<cr>
nnoremap <Leader>rn :set relativenumber<cr>

" ============================================================================
" KEYBINDINGS - CUSTOM LEADER COMMANDS
" ============================================================================
nnoremap <Leader>w :w<cr>                    " Save file
nnoremap <Leader>q :q<cr>                    " Quit
nnoremap <Leader>x :wq<cr>                   " Save and quit
nnoremap <Leader>ee :e<Space>                " Edit file
nnoremap <Leader>vs :vsplit<cr>              " Vertical split
nnoremap <Leader>hs :split<cr>               " Horizontal split
nnoremap <Leader>tn :tabnew<cr>              " New tab
nnoremap <Leader>tc :tabclose<cr>            " Close tab
nnoremap <Leader>to :tabo<cr>                " Close other tabs

" ============================================================================
"KEYBINDINGS - CTAGS NAVIGATION
" ============================================================================
nnoremap <Leader>tt :!ctags -R<cr>           " Generate tags
nnoremap <C-]> <cmd>execute "tag " . expand("<cword>")<cr>  " Jump to definition
nnoremap <C-[> <cmd>pop<cr>                  " Jump back
nnoremap <Leader>ts :tag<Space>              " Search for tag
nnoremap <Leader>tl :tags<cr>                " List tag stack
nnoremap <Leader>tn :tnext<cr>               " Next tag match
nnoremap <Leader>tp :tprev<cr>               " Previous tag match

" ============================================================================
" KEYBINDINGS - SAVE AND EDIT CONFIG
" ============================================================================
map <C-s> :w <CR>
imap <C-s> <esc> :w <CR>
nnoremap <Leader>v :tabnew ~/.config/nvim/init.vim<CR>

" ============================================================================
" KEYBINDINGS - FILE TREE
" ============================================================================
nnoremap <Leader>tree <cmd>NvimTreeToggle<CR>

" ============================================================================
" KEYBINDINGS - TELESCOPE (FILE FINDER)
" ============================================================================
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>

" ============================================================================
" KEYBINDINGS - LSP
" ============================================================================
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap gh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>

" ============================================================================
" KEYBINDINGS - DIAGNOSTICS
" ============================================================================
nnoremap <leader>d <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <leader>q <cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d <cmd>lua vim.diagnostic.goto_next()<CR>

" ============================================================================
" KEYBINDINGS - RELOAD CONFIG
" ============================================================================
nnoremap <Leader>r <cmd>source ~/.config/nvim/init.vim<CR>

" ============================================================================
" FOLDING KEYBINDINGS (Reference)
" ============================================================================
" zc = close fold
" zo = open fold
" za = toggle fold
" zM = close all folds
" zR = open all folds
