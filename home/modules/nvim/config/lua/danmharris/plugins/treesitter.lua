return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "beancount",
                "elixir",
                "go",
                "hcl",
                "lua",
                "ruby",
                "vim",
                "vimdoc",
                "yaml",
            },
            highlight = {
                enable = true,
            },
        },
    },
}
