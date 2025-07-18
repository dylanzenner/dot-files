let mapleader = " "

call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'shaunsingh/nord.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-treesitter/nvim-treesitter', { 'lazy': 'falze', 'branch': 'main', 'build': ':TSUpdate'}

call plug#end()

colorscheme nord

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>