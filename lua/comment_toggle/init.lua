local M = {}

local default_comments = {
  lua = "--",
  python = "#",
  sql = "--",
  vim = '"',
  sh = "#",
  bash = "#",
  zsh = "#",
  ruby = "#",
  yaml = "#",
  toml = "#",
  conf = "#",
  make = "#",
  dockerfile = "#",
}

local comments = {}

local function range_bounds(opts)
  return math.min(opts.line1, opts.line2), math.max(opts.line1, opts.line2)
end

local function comment_out(opts)
  local marker = comments[vim.bo.filetype] or "//"
  local s, f = range_bounds(opts)
  vim.api.nvim_command(s .. "," .. f .. "s:^:" .. marker .. ":")
  vim.api.nvim_command("noh")
end

local function uncomment(opts)
  local marker = comments[vim.bo.filetype] or "//"
  local s, f = range_bounds(opts)
  pcall(vim.api.nvim_command, s .. "," .. f .. [[s:^\(\s\{-\}\)]] .. marker .. [[:\1:]])
  vim.api.nvim_command("noh")
end

local function toggle(opts)
  local marker = comments[vim.bo.filetype] or "//"
  local s, f = range_bounds(opts)

  local lines = vim.api.nvim_buf_get_lines(0, s - 1, f, false)
  local pattern = "^%s*" .. vim.pesc(marker)

  local all_commented = true
  for _, line in ipairs(lines) do
    local is_blank = line:match("^%s*$") ~= nil
    local is_commented = line:match(pattern) ~= nil
    if not is_blank and not is_commented then
      all_commented = false
      break
    end
  end

  if all_commented then
    uncomment(opts)
  else
    comment_out(opts)
  end
end

M.toggle = toggle
M.comment_out = comment_out
M.uncomment = uncomment

function M.setup(opts)
  opts = opts or {}
  comments = vim.tbl_extend("force", default_comments, opts.comments or {})

  vim.api.nvim_create_user_command("ToggleComment", toggle, { range = true })
  vim.api.nvim_create_user_command("CommentOut", comment_out, { range = true })
  vim.api.nvim_create_user_command("Uncomment", uncomment, { range = true })

  if opts.keymap ~= false then
    local key = opts.keymap or "<leader>?"
    vim.keymap.set({ "n", "v" }, key, ":ToggleComment<CR>",
      { silent = true, desc = "Toggle comment" })
  end
end

return M
