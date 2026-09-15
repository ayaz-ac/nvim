-- Ghostty "Breeze" (dark). `ansi` is verbatim from the Ghostty theme file.
-- Breeze puts its vivid colors in slots 1-6, so the named roles prefer those.
require("ghostty-theme").load("breeze", {
  ansi = {
    [0] = "#31363b",
    "#ed1515", "#11d116", "#f67400", "#1d99f3", "#9b59b6", "#1abc9c", "#eff0f1",
    "#7f8c8d", "#c0392b", "#1cdc9a", "#fdbc4b", "#3daee9", "#8e44ad", "#16a085", "#fcfcfc",
  },
  background = "dark",
  bg = "#31363b",
  fg = "#eff0f1",
  bg_alt = "#3b4045",
  bg_float = "#2a2e32",
  selection = "#4d5359",
  border = "#4d5359",
  comment = "#7f8c8d",
  muted = "#5c6368",
  red = "#ed1515",
  green = "#11d116",
  green_alt = "#1cdc9a",
  yellow = "#f67400",
  yellow_alt = "#fdbc4b",
  blue = "#1d99f3",
  blue_alt = "#3daee9",
  magenta = "#9b59b6",
  magenta_alt = "#b478d0", -- lightened from palette 13, too dark for keywords
  cyan = "#1abc9c",
  cyan_alt = "#16a085",
  diff_add = "#28402f",
  diff_change = "#3d3a2b",
  diff_delete = "#43302e",
  diff_text = "#544c32",
})
