-- ============================================
-- BASIC SETTINGS
-- ============================================
vim.opt.number = true                    -- Show line numbers
vim.opt.relativenumber = true            -- Relative line numbers
vim.opt.mouse = 'a'                      -- Enable mouse
vim.opt.ignorecase = true                -- Case insensitive search
vim.opt.smartcase = true                 -- Unless uppercase in search
vim.opt.expandtab = true                 -- Use spaces instead of tabs
vim.opt.shiftwidth = 2                   -- Indent by 4 spaces
vim.opt.tabstop = 2                      -- Tab = 4 spaces
vim.opt.softtabstop = 2                  -- Backspace deletes 4 spaces
vim.opt.autoindent = true                -- Auto indent new lines
vim.opt.smartindent = true               -- Smart indenting
vim.opt.clipboard = 'unnamedplus'        -- System clipboard
vim.opt.termguicolors = true             -- True color support
vim.opt.cursorline = true                -- Highlight current line
vim.opt.wrap = false                     -- No line wrapping
vim.opt.scrolloff = 8                    -- Keep 8 lines visible when scrolling
vim.opt.sidescrolloff = 8                -- Keep 8 columns visible
vim.opt.signcolumn = 'yes'               -- Always show sign column
vim.opt.updatetime = 250                 -- Faster completion
vim.opt.timeoutlen = 300                 -- Faster key sequence completion
vim.opt.backup = false                   -- No backup files
vim.opt.writebackup = false              -- No backup when writing
vim.opt.swapfile = false                 -- No swap files
vim.opt.undofile = true                  -- Persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo')  -- Undo directory

-- Language and encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.cmd("language en_US")

-- Create undo directory if it doesn't exist
vim.fn.mkdir(vim.fn.expand('~/.config/nvim/undo'), 'p')

-- ============================================
-- LEADER KEY
-- ============================================
vim.g.mapleader = " "                    -- Space as leader key
vim.g.maplocalleader = " "

-- ============================================
-- KEY MAPPINGS
-- ============================================
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Easy escape from insert mode
keymap('i', 'jj', '<Esc>')
keymap('i', 'jk', '<ESC>', opts)
keymap('i', 'kj', '<ESC>', opts)

-- Save file
keymap('n', '<leader>w', ':w<CR>', opts)
keymap('n', '<leader>W', ':wa<CR>', opts)      -- Save all

-- Quit
keymap('n', '<leader>q', ':q<CR>', opts)
keymap('n', '<leader>Q', ':qa<CR>', opts)      -- Quit all

-- Save and quit
keymap('n', '<leader>x', ':x<CR>', opts)

-- Split navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize splits
keymap('n', '<C-S-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-S-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-S-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-S-Right>', ':vertical resize +2<CR>', opts)

-- Buffer navigation
keymap('n', '<Tab>', ':bnext<CR>', opts)
keymap('n', '<S-Tab>', ':bprevious<CR>', opts)
keymap('n', '<leader>bd', ':bdelete<CR>', opts)    -- Close buffer

-- Clear search highlight
keymap('n', '<leader>h', ':nohl<CR>', opts)

-- Better indenting (stay in visual mode)
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
keymap('n', '<C-d>', '<C-d>zz', opts)
keymap('n', '<C-u>', '<C-u>zz', opts)
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)

-- Better paste (don't replace clipboard)
keymap('v', 'p', '"_dP', opts)

-- Cooy and paste mappings
keymap('n', '<leader>pa', 'ggVGp')

-- Select all
keymap('n', '<leader>sa', 'ggVG')

-- Copy current file path to clipboard
keymap('n', '<leader>cp', ':let @+=expand("%:.")<CR>')

-- "Select to end of line"
keymap("n", "L", "vg_")

-- Opening/escaping terminal windows
-- Open terminal
keymap("n", "<leader>t", ":terminal<CR>")

-- Opening terminal in vertical/horizontal split
keymap("n", "<leader>Tsv", ":vsp term://")
keymap("n", "<leader>Tsh", ":sp term://")

-- Escape terminal mode
keymap('t', '<C-;>', '<C-\\><C-n>')

-- Quick list navigation
keymap('n', '<leader>j', ':cnext<CR>', opts)
keymap('n', '<leader>k', ':cprev<CR>', opts)

-- Disable netrw (using neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================================
-- AUTO COMMANDS
-- ============================================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
	group = 'YankHighlight',
	callback = function()
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
	end,
})

-- Remove trailing whitespace on save
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
	group = 'TrimWhitespace',
	pattern = '*',
	command = [[%s/s+$//e]],
})

-- Auto-create parent directories when saving
autocmd('BufWritePre', {
	callback = function()
		local dir = vim.fn.expand('<afile>:p:h')
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, 'p')
		end
	end,
})

-- Allow ctrl-e in terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
	pattern = '*',
	callback = function()
		-- Pass common completion keys to terminal
		local opts = { buffer = 0, noremap = true }
		vim.keymap.set('t', '<C-e>', '<C-e>', opts)
		vim.keymap.set('t', '<C-f>', '<C-f>', opts)
		vim.keymap.set('t', '<C-n>', '<C-n>', opts)
		vim.keymap.set('t', '<C-p>', '<C-p>', opts)
	end,
})

-- Return to last edit position when opening files
autocmd('BufReadPost', {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- ============================================
-- CUSTOM COMMANDS
-- ============================================
-- Trim trailing whitespace
vim.api.nvim_create_user_command('TrimWhitespace', [[%s/s+$//e]], {})

-- Toggle line numbers
vim.api.nvim_create_user_command('ToggleNumbers', function()
	vim.opt.number = not vim.opt.number:get()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})

-- ============================================
-- STATUS LINE
-- ============================================
vim.opt.laststatus = 2
vim.opt.showmode = false

-- Simple custom statusline
vim.opt.statusline = table.concat({
	' %f',              -- File path
	' %m',              -- Modified flag
	' %r',              -- Readonly flag
	'%=',               -- Right align
	' %y',              -- File type
	' %p%%',            -- Percentage through file
	' %l:%c ',          -- Line:Column
})

-- ============================================
-- Custom filetype associations
-- ============================================

-- EJS
--
vim.cmd('autocmd BufNewFile,BufRead *.ejs set filetype=html')
vim.treesitter.language.register('html', 'ejs')

-- ============================================
-- PLUGIN MANAGEMENT WITH LAZY.NVIM
-- ============================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup({
	-- Lazygit
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}
	},

	-- Color schemes
	{ "EdenEast/nightfox.nvim" ,priority= 1000 },
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = { contrast = "soft" } },

	-- Vim autoread
	{  'djoshea/vim-autoread' }, 

	-- LSP Configuration
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "?",
					package_pending = "?",
					package_uninstalled = "?"
				}
			}
		}
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			vim.lsp.enable('pyright')
			vim.lsp.enable('ts_ls')
			vim.lsp.enable('clangd')
			vim.lsp.enable('omnisharp')

			-- Global mappings
			vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

			-- LSP mappings
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<space>f', function()
						vim.lsp.buf.format { async = true }
					end, opts)
				end,
			})
		end,
	},

	-- GitHub copilot
	{
		"github/copilot.vim",
		event = "InsertEnter",
		init = function()
			-- Tabããããç¡å¹åï¼è¶éè¦ï¼
			vim.g.copilot_no_tab_map = true
		end,
		config = function()
			-- Copilotç¢ºå®: Ctrl-l
			vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
				expr = true,
				replace_keycodes = false,
				silent = true,
			})

			-- (ä»»æ) æ¬¡/ååè£
			vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)", { silent = true })
			vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)", { silent = true })

			-- (ä»»æ) åè£ãæç¤ºçã«åºãããæ
			vim.keymap.set("i", "<C-s>", "<Plug>(copilot-suggest)", { silent = true })
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

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
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				}, {
					{ name = 'buffer' },
					{ name = 'path' },
				})
			})
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "OXY2DEV/markview.nvim" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"typescript",
					"javascript",
					"c",
					"cpp",
					"c_sharp",
					"html",
					"css",
					"json",
					"yaml",
					"markdown",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
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
		end,
	},

	-- Markdown preview
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		-- For `nvim-treesitter` users.
		priority = 49,
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" },
				typescript = { "eslint" },
				javascript = { "eslint" },
				c = { "cppcheck" },
				cpp = { "cppcheck" },
				csharp = { "omnisharp" },  -- OmniSharp LSP provides diagnostics
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require('tiny-inline-diagnostic').setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
		end
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				window = {
					position = "left",
					width = 30,
				},
				filesystem = {
					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
			})
			vim.keymap.set('n', '<C-n>', '<cmd>Neotree toggle<cr>')
			vim.keymap.set('n', '<leader>o', ':Neotree focus<CR>', opts)
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto"
				}
			})
		end,
	},
})

-- ============================================
-- COLORSCHEME
-- ============================================
-- Set colorscheme (using built-in schemes)
vim.cmd.colorscheme('carbonfox')  -- or 'slate', 'desert', 'pablo'

print("Neovim config loaded successfully!")
