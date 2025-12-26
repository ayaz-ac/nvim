return {
  'lervag/vimtex',
  config = function()
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_compiler_latexmk = {
      continuous = 1,
    }
  end
}
