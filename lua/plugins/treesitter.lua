return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- use a última versão do master para evitar bugs de caminhos
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Em vez de require direto no topo, fazemos o setup de forma segura
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
        return
    end

    configs.setup({
      ensure_installed = {
        "bash", "css", "dockerfile", "go", "html", "javascript",
        "json", "lua", "markdown", "php", "python", "scss",
        "sql", "typescript", "vim", "yaml", "rust", "c", "java", "vimdoc", "query"
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })

    -- Configurações de folding (opcional)
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldlevel = 99
  end,
}
