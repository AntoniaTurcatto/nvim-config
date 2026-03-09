return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "lua_ls", 
          "rust_analyzer", 
          "pyright", -- Adicionado Python
          "clangd",  -- Adicionado C/C++
          -- "marksman" -- Adicionado Markdown
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { 
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- Adicionado como dependência para as sugestões
    },
    config = function()
      local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")

      -- Define as capacidades para o autocompletar (se o plugin existir)
      local capabilities = ok_cmp and cmp_lsp.default_capabilities() or {}

      if ok_mlsp and mlsp.setup_handlers then
        mlsp.setup_handlers({
          function(server_name)
            -- Configuração unificada para cada servidor
            vim.lsp.config(server_name, {
              capabilities = capabilities,
            })
            vim.lsp.enable(server_name)
          end,
        })
      else
        -- Fallback manual se o setup_handlers falhar
        local servers = { "lua_ls", "rust_analyzer" }
        for _, server in ipairs(servers) do
          vim.lsp.config(server, {
            capabilities = capabilities,
          })
          vim.lsp.enable(server)
        end
        
        if not ok_mlsp then
          vim.notify("Mason-LSPConfig não encontrado. Usando setup manual.", vim.log.levels.WARN)
        end
      end
    end,
  },
}
