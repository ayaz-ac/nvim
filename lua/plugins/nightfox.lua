return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("nightfox").setup({})

    -- Track the terminal's light/dark mode and match Ghostty's theme
    -- (light:Dawnfox,dark:Duskfox). Neovim subscribes to DEC mode 2031 and
    -- re-queries OSC 11, so 'background' updates live when the macOS
    -- appearance flips at day/night -- no polling needed.
    local function apply_theme()
      local want = vim.o.background == "light" and "dawnfox" or "duskfox"
      -- Setting the colorscheme also sets 'background', which re-enters this
      -- callback; bail out when we are already on the right one.
      if vim.g.colors_name ~= want then
        vim.cmd.colorscheme(want)
      end
    end

    apply_theme()

    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = apply_theme,
      desc = "Match colorscheme to terminal light/dark mode",
    })
  end,
}
