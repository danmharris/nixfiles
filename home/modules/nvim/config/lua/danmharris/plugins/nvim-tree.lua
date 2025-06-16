return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "NvimTreeFindFileToggle",
        keys = {
            { "<C-n>", ":NvimTreeFindFileToggle<CR>" },
        },
        opts = {
            renderer = {
                group_empty = true,
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
        },
    },
}
