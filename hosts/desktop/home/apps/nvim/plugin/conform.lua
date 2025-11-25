-- plugin/conform.lua
require("conform").setup({
  formatters_by_ft = {
    nix = { "alejandra" },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.nix",
  callback = function()
    require("conform").format({ async = false })
  end,
})

