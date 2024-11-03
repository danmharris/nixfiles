local wk = require("which-key")
local builtin = function()
    return require("telescope.builtin")
end
wk.register({
    f = {
        name = "find",
        c = { ":NvimTreeFindFile<CR>", "Find current file" },
        f = {
            function()
                builtin().find_files()
            end,
            "Find files",
        },
        g = {
            function()
                builtin().live_grep()
            end,
            "Grep",
        },
        b = {
            function()
                builtin().buffers()
            end,
            "Find buffers",
        },
    },
    g = {
        name = "goto",
        D = {
            function()
                vim.lsp.buf.declaration()
            end,
            "Go to declaration",
        },
        d = {
            function()
                vim.lsp.buf.definition()
            end,
            "Go to definition",
        },
        h = {
            function()
                vim.lsp.buf.hover()
            end,
            "Hover",
        },
        i = {
            function()
                vim.lsp.buf.implementation()
            end,
            "Go to implementation",
        },
    },
    v = {
        name = "vcs",
        s = { ":Git<CR>", "Git status" },
        d = { ":Git diff<CR>", "Git diff" },
        c = { ":Git commit<CR>", "Git commit" },
        p = { ":Git pull<CR>", "Git pull" },
    },
}, { prefix = "<leader>" })
