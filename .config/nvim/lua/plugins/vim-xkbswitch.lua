return {
  {
    "lyokha/vim-xkbswitch",
    init = function()
      -- enable automatically
      vim.g.XkbSwitchEnabled = 1

      -- point to the shared library if needed
      -- adjust path depending on your system
      -- vim.g.XkbSwitchLib = "/usr/local/lib/libxkbswitch.so"
    end,
  },
}

