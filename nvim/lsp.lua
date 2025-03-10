local lsp = require('lspconfig')
local coq = require('coq')

lsp.pyright.setup{}

lsp.clangd.setup({
        cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
        init_options = {
            fallbackFlags = { '-std=c++17' },
        },
    })
