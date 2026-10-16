return
{
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<C-y>"] = false,
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
