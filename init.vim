" Be improved
set nocompatible
" Required
filetype off

call plug#begin('~/.config/nvim')
    Plug 'VundleVim/Vundle.vim'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    "Add icons to NERDTree
    Plug 'ryanoasis/vim-devicons'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    "Pre-view and search files
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    "Move things
    Plug 'nvim-treesitter/nvim-treesitter'
    "Theme
    Plug 'arcticicestudio/nord-vim'
    "Adds indentation guides to all lines
    Plug 'lukas-reineke/indent-blankline.nvim'
    "Highlighting other uses of the word under the cursor
    Plug 'RRethy/vim-illuminate'
    "todo Highlight and search
    Plug 'folke/todo-comments.nvim'
    "Status bar
    Plug 'nvim-lualine/lualine.nvim'
    "Devicons for status bar
    Plug 'kyazdani42/nvim-web-devicons'
    "Auto Complete
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
call plug#end()

"Inicia NERDTree, si un archivo es especificado, mueve el cursor hacia la ventana
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" Toggle and focus nerdtree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

"Al salir de vim si NERDTree es la unica ventana que falta
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"NERDTree muestra archivos ocultos
let NERDTreeShowHidden=1

set title  " Muestra el nombre del archivo en la ventana de la terminal
set number  " Muestra los números de las líneas
set number relativenumber
set mouse=a  " Permite la integración del mouse (seleccionar texto, mover el cursor)

set nowrap  " No dividir la línea si es muy larga

set cursorline  " Resalta la línea actual
set colorcolumn=120  " Muestra la columna límite a 120 caracteres

" Indentación a 2 espacios
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set expandtab  " Insertar espacios en lugar de <Tab>s


set hidden  " Permitir cambiar de buffers sin tener que guardarlos

set ignorecase  " Ignorar mayúsculas al hacer una búsqueda
set smartcase  " No ignorar mayúsculas si la palabra a buscar contiene mayúsculas

set termguicolors  " Activa true colors en la terminal
colorscheme nord " Nombre del tema

let g:mapleader = ' ' "Definir espacio como la tecla líder.

nnoremap <leader>g :w<CR>  " Guardar con <líder> + g

nnoremap <leader>e :e $MYVIMRC<CR>  " Abrir el archivo init.vim con <líder> + e

" Usar <líder> + c para copiar al portapapeles
vnoremap <leader>c "+c
nnoremap <leader>c "+c

" Usar <líder> + x para cortar al portapapeles
vnoremap <leader>x "+x
nnoremap <leader>x "+x

" Usar <líder> + p para pegar desde el portapapeles
nnoremap <leader>v "+p
vnoremap <leader>v "+p

"Abrir Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>

" Moverse al buffer siguiente con <líder> + l
nnoremap <leader>l :bnext<CR>

" Moverse al buffer anterior con <líder> + j
nnoremap <leader>j :bprevious<CR>

" Cerrar el buffer actual con <líder> + q
nnoremap <leader>q :bdelete<CR>

" usar portapapeles del sistema
set clipboard+=unnamedplus

" Sustituir palabras
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

"usar zz para cerrar y guardar
nnoremap zz :wq<CR>

"Usar zq para cerrar sin guardar
nnoremap zq :q!<CR>

"Mover info
vmap("J", ":m '>+1<CR>gv=gv") 
vmap("K", ":m '<-2<CR>gv=gv")
" Activa el todo plugin
lua require("todo-comments").setup {}

lua require("mason").setup()
" Activa la status bar
lua require('lualine').setup()
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({   
    ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            if luasnip.expandable() then
                luasnip.expand()
            else
                cmp.confirm({
                    select = true,
                })
            end
        else
            fallback()
        end
    end),

    ["<Tab>"] = cmp.mapping(function(fallback)
    -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
    if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
            cmp.confirm()
            end
        else
            fallback()
            end
            end, { "i", "s", "c", }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    capabilities = capabilities
  }
EOF

lua <<EOF
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
    end)

    -- to learn how to use mason.nvim
    -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
    require('mason').setup({})
    require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        function(server_name)
        require('lspconfig')[server_name].setup({})
        end,
    },
    })
EOF

