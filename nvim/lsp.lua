local lspconfig = require('lspconfig')
local coq = require('coq')

vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)

    })

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.pyright.setup{}

lspconfig.clangd.setup({
    cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
    init_options = { fallbackFlags = { '-std=c++17' }, },
})

lspconfig.eslint.setup({
    settings = {
        packageManager = 'npm'
    },
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end,
})

lspconfig.ts_ls.setup({
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
    tsserver_locale = "en",
    complete_function_calls = true,
    include_completions_with_insert_text = true,
  },
})
