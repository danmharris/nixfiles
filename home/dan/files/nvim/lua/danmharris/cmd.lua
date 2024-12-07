local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})

autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*/playbooks/*.yml",
    command = "set filetype=yaml.ansible",
})
