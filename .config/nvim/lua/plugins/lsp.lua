local on_attach = function(_, bufnr)
    local silent = {
        noremap = true,
        silent = true
    }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", silent)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", silent)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl",
    --     "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workpace_folders()))<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", silent)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", silent)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
    -- vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", silent)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", silent)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", silent)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>so",
    --     [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], silent)
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format { async = true }' ]])

    local cmp = require('cmp')
    local lspkind = require('lspkind')

    cmp.setup({
        sources = {
            {name = 'nvim_lsp'},
            {name = "supermaven"}
        },
        snippet = {
            expand = function(args)
                -- You need Neovim v0.10 to use vim.snippet
                vim.snippet.expand(args.body)
            end
        },
        formatting = {
            format = lspkind.cmp_format({
              mode = "symbol",
              max_width = 50,
              symbol_map = { Supermaven = "" }
            })
        },        
        mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({
                select = true
            })
        })
    })
end

local function lsp_get_config(server)
    local configs = require("lspconfig.configs")
    return rawget(configs, server)
end

local function lsp_disable(server, cond)
    local util = require("lspconfig.util")
    local def = lsp_get_config(server)
    def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config,
        function(config, root_dir)
            if cond(root_dir, config) then
                config.enabled = false
            end
        end)
end

return {{
    "neovim/nvim-lspconfig",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {
        "mason.nvim", 
        "williamboman/mason-lspconfig.nvim",
        "onsails/lspkind.nvim"
    },
    opts = {
        diagnostics = {
            underline = true,
            update_in_insert = false,
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●"
            },
            severity_sort = true
        },
        autoformat = true,
        format = {
            formatting_options = nil,
            timeout_ms = nil
        },
        setup = {},
        servers = {
            jsonls = {},
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = {
                            checkThirdParty = false
                        },
                        completion = {
                            callSnippet = "Replace"
                        }
                    }
                }
            }
        }
    },
    config = function(_, opts)
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args, name)
                local buffer = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and (not name or client.name == name) then
                    return on_attach(client, buffer)
                end
            end
        })

        vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

        local servers = opts.servers
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(),
            has_cmp and cmp_nvim_lsp.default_capabilities() or {}, opts.capabilities or {})

        local function setup(server)
            local server_opts = vim.tbl_deep_extend("force", {
                capabilities = vim.deepcopy(capabilities)
            }, servers[server] or {})

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then
                    return
                end
            elseif opts.setup["*"] then
                if opts.setup["*"](server, server_opts) then
                    return
                end
            end
            require("lspconfig")[server].setup(server_opts)
        end

        -- get all the servers that are available thourgh mason-lspconfig
        local have_mason, mlsp = pcall(require, "mason-lspconfig")
        local all_mslp_servers = {}
        if have_mason then
            all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
        end

        local ensure_installed = {}
        for server, server_opts in pairs(servers) do
            if server_opts then
                server_opts = server_opts == true and {} or server_opts
                ensure_installed[#ensure_installed + 1] = server
            end
        end

        mlsp.setup({
            ensure_installed = ensure_installed
        })
        mlsp.setup_handlers({setup})

        if lsp_get_config("denols") and lsp_get_config("vtsls") then
            local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
            lsp_disable("vtsls", is_deno)
            lsp_disable("denols", function(root_dir)
                return not is_deno(root_dir)
            end)
        end
    end
}, {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {{
        "<leader>cm",
        "<cmd>Mason<cr>",
        desc = "Mason"
    }},
    opts = {
        ensure_installed = {"stylua", "json-lsp", "lua-language-server", "shfmt", "vtsls", "rust-analyzer"}
    },
    config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end
}, {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/nvim-cmp'}}
