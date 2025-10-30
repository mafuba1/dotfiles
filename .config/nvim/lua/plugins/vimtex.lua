return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-synctex=0",
      },
    }
    vim.g.vimtex_complete_enabled = 1   -- enable completion
    vim.g.vimtex_quickfix_mode = 0      -- disable quickfix auto open
    vim.g.vimtex_indent_enabled = 1     -- smart indenting
  end
}
