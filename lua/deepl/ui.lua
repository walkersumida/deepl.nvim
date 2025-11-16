local M = {}

--- Calculate the number of display lines considering text wrapping
---@param lines table Lines of text
---@param width number Window width
---@return number Total display lines
local function calculate_display_lines(lines, width)
  local total_lines = 0
  for _, line in ipairs(lines) do
    -- Calculate how many display lines this logical line will take when wrapped
    local display_lines = math.ceil(vim.fn.strwidth(line) / width)
    if display_lines == 0 then
      display_lines = 1 -- Empty lines still take 1 line
    end
    total_lines = total_lines + display_lines
  end
  return total_lines
end

--- Create a floating window and display translation result
---@param text string Text to display
---@param original_text string|nil Original text (optional)
function M.show_translation(text, original_text)
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Prepare content to display
  local lines = {}

  if original_text then
    table.insert(lines, "【Original Text】")
    for line in original_text:gmatch("[^\n]+") do
      table.insert(lines, line)
    end
    table.insert(lines, "")
    table.insert(lines, "【Translation】")
  end

  for line in text:gmatch("[^\n]+") do
    table.insert(lines, line)
  end

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  -- Calculate window size
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- Calculate width as 60% of screen width
  local win_width = math.floor(width * 0.6)

  -- Calculate height: 80% of screen height (max) or 20 lines (min)
  local max_height = math.floor(height * 0.8)
  local min_height = 20

  -- Calculate actual display lines considering text wrapping
  local display_lines = calculate_display_lines(lines, win_width)
  local content_height = display_lines

  -- Use max_height for long content, min_height for short content
  if content_height > max_height then
    win_height = max_height
  else
    win_height = math.max(min_height, content_height)
  end

  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  -- Window options
  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " DeepL Translation ",
    title_pos = "center",
  }

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window options
  vim.api.nvim_win_set_option(win, "wrap", true)
  vim.api.nvim_win_set_option(win, "cursorline", true)

  -- Close window with q or ESC
  local close_keys = { "q", "<Esc>" }
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "<Cmd>close<CR>", { noremap = true, silent = true })
  end
end

--- Show loading indicator
---@return number buffer_id Loading buffer ID
---@return number window_id Loading window ID
function M.show_loading()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = { "Translating...", "", "Please wait..." }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_width = 30
  local win_height = 3

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = math.floor((height - win_height) / 2),
    col = math.floor((width - win_width) / 2),
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, false, opts)

  return buf, win
end

--- Close loading indicator
---@param buf number Buffer ID
---@param win number Window ID
function M.close_loading(buf, win)
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

return M
