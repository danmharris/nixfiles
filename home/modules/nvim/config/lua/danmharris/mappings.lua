local set = vim.keymap.set

set("n", "<C-l>", ":bn<cr>")
set("n", "<C-h>", ":bp<cr>")

set("n", "<leader>ws", ":split<cr>", { desc = "Split window horizontally" })
set("n", "<leader>wv", ":vsplit<cr>", { desc = "Split window vertically" })
set("n", "<leader>wh", "<C-w>h", { desc = "Move window left" })
set("n", "<leader>wj", "<C-w>j", { desc = "Move window down" })
set("n", "<leader>wk", "<C-w>k", { desc = "Move window up" })
set("n", "<leader>wl", "<C-w>l", { desc = "Move window right" })

set("n", "<leader>or", function() require("telescope.builtin").oldfiles() end, { desc = "Open recent files" })
set("n", "<C-p>", function() require("telescope.builtin").find_files() end, { desc = "Open files" })
set("n", "<leader>ob", function() require("telescope.builtin").buffers({ sort_mru = true }) end,
    { desc = "Open buffers" })

set("n", "<C-f>", function() require("telescope.builtin").live_grep() end, { desc = "Grep" })

set("n", "<leader>vs", ":Git<cr>", { desc = "Git status" })
set("n", "<leader>vP", ":Git push<cr>", { desc = "Git push" })
set("n", "<leader>vp", ":Git pull<cr>", { desc = "Git pull" })

local lsp = vim.lsp.buf
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP",
    callback = function(event)
        set("n", "gd", lsp.definition, { buffer = event.buf, desc = "Go to definition" })
        set("n", "gD", lsp.declaration, { buffer = event.buf, desc = "Go to declaration" })
        set("n", "gi", lsp.implementation, { buffer = event.buf, desc = "Go to implementation" })
        set("n", "gr", function() require("telescope.builtin").lsp_references() end,
            { buffer = event.buf, desc = "Show references" })
        set("n", "gl", function() require("telescope.builtin").diagnostics() end,
            { buffer = event.buf, desc = "Show diagnostics" })
        set("n", "<F2>", lsp.rename, { buffer = event.buf, desc = "Rename" })
        set("n", "<F4>", lsp.code_action, { buffer = event.buf, desc = "Code action" })
    end
})
