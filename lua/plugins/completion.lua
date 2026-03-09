return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- Fonte do LSP para o cmp
      "hrsh7th/cmp-buffer",       -- Sugestões baseadas no texto do arquivo atual
      "hrsh7th/cmp-path",         -- Sugestões de caminhos de arquivos
      "L3MON4D3/LuaSnip",         -- Engine de snippets (obrigatório para o cmp)
      "saadparwaiz1/cmp_luasnip", -- Fonte de snippets para o cmp
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
          ['<C-Space>'] = cmp.mapping.complete(), -- Força abrir o menu
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter confirma
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, -- Prioridade 1: LSP
          { name = 'luasnip' },  -- Prioridade 2: Snippets
        }, {
          { name = 'buffer' },   -- Prioridade 3: Palavras no arquivo
          { name = 'path' },     -- Prioridade 4: Caminhos
        })
      })
    end,
  }
}
