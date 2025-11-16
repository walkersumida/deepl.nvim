local M = {}

--- Get text selected in visual mode
---@return string|nil Selected text, or nil if no selection
function M.get_visual_selection()
  -- Get start and end positions of visual selection marks
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  -- Check if marks are valid (line number is 0 if marks are not set)
  if start_line == 0 or end_line == 0 then
    return nil
  end

  -- Get selected text
  local lines = vim.fn.getline(start_line, end_line)

  if type(lines) == "string" then
    lines = { lines }
  end

  if #lines == 0 then
    return nil
  end

  -- Handle multi-line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  return table.concat(lines, "\n")
end

--- Check if a string is empty
---@param str string|nil String to check
---@return boolean True if empty
function M.is_empty(str)
  return str == nil or str == ""
end

--- Display an error message
---@param msg string Error message
function M.error(msg)
  vim.notify("[DeepL] " .. msg, vim.log.levels.ERROR)
end

--- Display an info message
---@param msg string Info message
function M.info(msg)
  vim.notify("[DeepL] " .. msg, vim.log.levels.INFO)
end

return M
