-- BASIC SETTINGS ----------------------------------------------------------------
vim.cmd('language en_US')

-- Disable compatibility with vi which can cause unexpected issues.
vim.opt.compatible = false

-- Turn off bell
vim.opt.belloff = 'all'

-- Enable mouse click support
vim.opt.mouse = 'a'

-- Support true colors
vim.opt.termguicolors = true

-- Enable type file detection. Vim will be able to try to detect the type of file in use.
vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('filetype indent on')

-- Turn syntax highlighting on.
vim.cmd('syntax on')

-- Show line numbers by default in normal buffers
vim.opt.number = true

-- Hide line numbers only in terminal buffers
vim.api.nvim_create_augroup('TerminalSettings', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
    group = 'TerminalSettings',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end
})
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'term://*',
    group = 'TerminalSettings',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end
})
vim.api.nvim_create_autocmd('BufLeave', {
    pattern = 'term://*',
    group = 'TerminalSettings',
    callback = function()
        vim.opt_local.number = true
    end
})

-- Make backspace work like in most other programs
vim.opt.backspace = 'indent,eol,start'

-- Highlight cursor line
vim.opt.cursorline = true

-- Set indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- No backup files
vim.opt.backup = false

-- Scrolling behavior
vim.opt.scrolloff = 10

-- No line wrapping
vim.opt.wrap = false

-- Search settings
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.hlsearch = true

-- Command display
vim.opt.showcmd = true
vim.opt.showmode = true

-- Command history
vim.opt.history = 1000

-- Completion menu
vim.opt.wildmenu = true
vim.opt.wildmode = 'list:longest'
vim.opt.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'

-- Use html binding for ejs files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.ejs",
    command = "set filetype=html"
})

-- PLUGINS ----------------------------------------------------------------

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim
require("lazy").setup({
    -- Dev plugins
    { "mfussenegger/nvim-lint" },
    { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-tree/nvim-web-devicons" },
    
    -- File navigation
    { 
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                    custom = {
                        [[^\.git$]],
                        [[\.jpg$]],
                        [[\.mp4$]],
                        [[\.ogg$]],
                        [[\.iso$]],
                        [[\.pdf$]],
                        [[\.pyc$]],
                        [[\.odt$]],
                        [[\.png$]],
                        [[\.gif$]],
                        [[\.db$]]
                    },
                },
            })
        end,
    },
    { 
        "nvim-telescope/telescope.nvim", 
        dependencies = { 
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
            -- Load extensions
            pcall(require('telescope').load_extension, 'fzf')
        end,
    },
    { 
        "nvim-telescope/telescope-fzf-native.nvim", 
        build = "make" 
    },
    
    -- Git
    { "tpope/vim-fugitive" },
    { 
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup()
        end
    },
    
    -- Editing tools
    { "tpope/vim-surround" },
    { 
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup()
        end
    },
    { "github/copilot.vim" },
    
    -- Treesitter for better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query", 
                    "javascript", "typescript", "python", "rust",
                    "cpp", "html", "css", "json", "yaml", "toml",
                    "markdown", "markdown_inline"
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
            
            -- Set foldmethod to use treesitter
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt.foldenable = false  -- Start with folds open
        end,
    },
    
    -- UI
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            })
        end,
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    numbers = "none",
                    close_command = "bdelete! %d",
                    right_mouse_command = "bdelete! %d",
                    left_mouse_command = "buffer %d",
                    indicator = {
                        icon = "▎",
                        style = "icon",
                    },
                    buffer_close_icon = "",
                    modified_icon = "●",
                    close_icon = "",
                    left_trunc_marker = "",
                    right_trunc_marker = "",
                    separator_style = "thin",
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    enforce_regular_tabs = false,
                    always_show_bufferline = true,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "center",
                            separator = true
                        }
                    },
                }
            })
        end,
    },
    
    -- LSP and completion
    { "neovim/nvim-lspconfig" },
    { "ms-jpq/coq_nvim", branch = "coq" },
    { "ms-jpq/coq.artifacts", branch = "artifacts" },
    { "ms-jpq/coq.thirdparty", branch = "3p" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "nvimtools/none-ls-extras.nvim" },
    -- Formatting and linting - replace null-ls with none-ls (maintained fork)
    {
        "nvimtools/none-ls.nvim",  -- Community maintained fork of null-ls
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Formatters
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.clang_format,
                    null_ls.builtins.formatting.rustfmt,
                    
                    -- Linters
                    require("none-ls.diagnostics.eslint"),
                    require("none-ls.diagnostics.flake8"),
                    
                    -- Code actions   
                    -- null_ls.builtins.code_actions.eslint,
                },
            })
        end,
    },
    
    -- Syntax
    { "prisma/vim-prisma" },
    
    -- Theme
    { "EdenEast/nightfox.nvim" },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                },
            })
        end,
    },
})

-- VIMSCRIPT COMPATIBILITY ------------------------------------------------

-- This will enable code folding for Vim files
vim.api.nvim_create_augroup('filetype_vim', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = 'filetype_vim',
    pattern = 'vim',
    command = 'setlocal foldmethod=marker'
})

-- Set theme
vim.opt.background = 'dark'
vim.cmd('colorscheme tokyonight')

-- STATUS LINE ------------------------------------------------------------

-- Enable the statusline
vim.opt.laststatus = 2

-- Indicator like -- INSERT -- is unnecessary with statusline
vim.opt.showmode = false

-- Statusline is now handled by lualine.nvim

-- MAPPINGS ---------------------------------------------------------------

-- Set the semicolon as the leader key
vim.g.mapleader = ';'

-- Press ;; to jump back to the last cursor position
vim.keymap.set('n', '<leader>;', '``', { silent = true })

-- Press \p to print the current file
vim.keymap.set('n', '<leader>p', ':%w !lp<CR>', { silent = true })

-- Type jj to exit insert mode quickly
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Comment/uncomment with ,/
vim.keymap.set('n', ',/', function() 
    require('Comment').api.toggle.linewise.current() 
end, { silent = true })

vim.keymap.set('v', ',/', function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require('Comment').api.toggle.linewise(vim.fn.visualmode())
end, { silent = true })

-- Press the space bar to type the : character in command mode
vim.keymap.set('n', '<space>', ':', { noremap = true })

-- Center the cursor vertically when moving to the next word during a search
vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })

-- Clipboard yank and paste
-- Yank all the content with ,ya
vim.keymap.set('n', ',ya', 'ggVG"+y<C-O>', { noremap = true })
-- Yank line in normal mode, selection in visual mode
vim.keymap.set('n', ',y', '"+y', { noremap = true })
vim.keymap.set('v', ',y', '"+y', { noremap = true })
-- Paste text
vim.keymap.set('n', ',p', '"+p', { noremap = true })
vim.keymap.set('v', ',p', '"+p', { noremap = true })

-- Map the F5 key to run a Python script inside Vim
vim.keymap.set('n', '<f5>', ':w <CR>:!clear <CR>:!python3 % <CR>', { noremap = true })

-- Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l
vim.keymap.set('n', '<c-j>', '<c-w>j', { noremap = true })
vim.keymap.set('n', '<c-k>', '<c-w>k', { noremap = true })
vim.keymap.set('n', '<c-h>', '<c-w>h', { noremap = true })
vim.keymap.set('n', '<c-l>', '<c-w>l', { noremap = true })

-- Buffer navigation using bufferline
vim.keymap.set('n', '<c-left>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-right>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-up>', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-down>', ':BufferLineGoToBuffer -1<CR>', { noremap = true, silent = true })

-- Resize split windows
vim.keymap.set('n', '<c-s-up>', '<c-w>+', { noremap = true })
vim.keymap.set('n', '<c-s-down>', '<c-w>-', { noremap = true })
vim.keymap.set('n', '<c-s-left>', '<c-w>>', { noremap = true })
vim.keymap.set('n', '<c-s-right>', '<c-w><', { noremap = true })

-- Nvim-tree toggle (replacement for NERDTree)
vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Telescope mappings
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = "Find buffers" })
vim.keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = "Help tags" })
vim.keymap.set('n', '<leader>fr', function() require('telescope.builtin').oldfiles() end, { desc = "Recent files" })

-- Format document using none-ls (previously null-ls)
vim.keymap.set('n', '<leader>df', vim.lsp.buf.format, { noremap = true, silent = true })

-- DIAGNOSTICS AND LINTING SETUP ------------------------------------------

-- Configure diagnostics display (fix for error messages not showing)
vim.diagnostic.config({
    virtual_text = true,     -- Show diagnostics as virtual text
    signs = true,            -- Show signs in the sign column
    underline = true,        -- Underline text with issues
    update_in_insert = false, -- Only update diagnostics after leaving insert mode
    severity_sort = true,    -- Sort diagnostics by severity
    float = {                -- Configure floating window
        border = "rounded",
        source = "always",   -- Always show source
        header = "",
        prefix = "",
    },
})

-- Make diagnostic messages appear on hover
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- Format on save (optional, uncomment to enable)
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     callback = function()
--         vim.lsp.buf.format({ async = false })
--     end,
-- })

-- Setup nvim-lint
local lint = require('lint')
lint.linters_by_ft = {
    javascript = {'eslint'},
    typescript = {'eslint'},
    python = {'flake8'},
    -- Add other linters for languages you use
}

-- Setup a autocmd to trigger linting
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})

-- Bind a key to show diagnostics in a floating window
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })

-- Open Trouble (diagnostics) with a keystroke
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

-- Load the lsp config
require('lsp')
