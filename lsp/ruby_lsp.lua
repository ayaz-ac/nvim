-- ruby-lsp is the single source of RuboCop diagnostics (see lua/plugins/null-ls.lua).
-- The cops it reports have to come from the RuboCop pinned in the project's
-- Gemfile.lock, otherwise offenses drift from `bundle exec rubocop` and from CI.
--
-- How the version gets pinned, decided per project root:
--   * ruby-lsp is in the project bundle -> `bundle exec ruby-lsp`, exact lockfile versions.
--   * otherwise -> the Mason/global `ruby-lsp`, which composes .ruby-lsp/Gemfile from the
--     project Gemfile and re-execs the server under it, so RuboCop still resolves to the
--     pinned version.
-- In both cases BUNDLE_GEMFILE is pinned to this root and RUBYOPT/RUBYLIB are dropped, so a
-- bundle inherited from the launching shell (`bundle exec nvim`, nvim started in another
-- project) cannot swap in a different RuboCop.

local function exists(path)
  return (vim.uv or vim.loop).fs_stat(path) ~= nil
end

local function lock_has(root, gem)
  local f = io.open(root .. "/Gemfile.lock", "r")
  if not f then
    return false
  end
  for line in f:lines() do
    if line:find(gem, 1, true) then
      f:close()
      return true
    end
  end
  f:close()
  return false
end

local function project_root(config)
  return config.root_dir or vim.fn.getcwd()
end

return {
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
  cmd = function(dispatchers, config)
    local root = project_root(config)
    local gemfile = root .. "/Gemfile"
    local has_bundle = exists(gemfile)

    local cmd = { "ruby-lsp" }
    if has_bundle and lock_has(root, "ruby-lsp (") then
      cmd = { "bundle", "exec", "ruby-lsp" }
    end

    local env = { RUBYOPT = "", RUBYLIB = "" }
    if has_bundle then
      env.BUNDLE_GEMFILE = gemfile
    end

    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root, env = env })
  end,
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop" },
  },
  before_init = function(params, config)
    -- Only force RuboCop where the project actually configures it; elsewhere let ruby-lsp
    -- detect the formatter/linter from the bundle instead of failing to load a missing gem.
    if not exists(project_root(config) .. "/.rubocop.yml") then
      params.initializationOptions = { formatter = "auto" }
    end
  end,
}
