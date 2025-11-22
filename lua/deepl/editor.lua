local M = {}

--- Replace selected text with translation result
---@param selection table Selection info {text, start_line, start_col, end_line, end_col, buf_id}
---@param translation string Translation result
function M.replace_text(selection, translation)
  -- Split translation into lines
  local lines = vim.split(translation, "\n", { plain = true })

  -- Check if buffer is valid
  if not vim.api.nvim_buf_is_valid(selection.buf_id) then
    vim.notify("[DeepL] Original buffer is no longer valid", vim.log.levels.ERROR)
    return
  end

  -- Make buffer modifiable temporarily
  vim.api.nvim_buf_set_option(selection.buf_id, "modifiable", true)

  -- Replace lines (1-indexed to 0-indexed conversion for nvim_buf_set_lines)
  vim.api.nvim_buf_set_lines(selection.buf_id, selection.start_line - 1, selection.end_line, false, lines)

  -- Move cursor to the beginning of replaced text
  vim.api.nvim_win_set_cursor(0, { selection.start_line, 0 })

  vim.notify("[DeepL] Text replaced with translation", vim.log.levels.INFO)
end

--- Append translation after selected text
---@param selection table Selection info {text, start_line, start_col, end_line, end_col, buf_id}
---@param translation string Translation result
function M.append_text(selection, translation)
  -- Split translation into lines
  local lines = vim.split(translation, "\n", { plain = true })

  -- Add empty line before translation
  table.insert(lines, 1, "")

  -- Check if buffer is valid
  if not vim.api.nvim_buf_is_valid(selection.buf_id) then
    vim.notify("[DeepL] Original buffer is no longer valid", vim.log.levels.ERROR)
    return
  end

  -- Make buffer modifiable temporarily
  vim.api.nvim_buf_set_option(selection.buf_id, "modifiable", true)

  -- Insert lines after the selected text (1-indexed to 0-indexed conversion)
  -- selection.end_line is the position to insert after
  vim.api.nvim_buf_set_lines(selection.buf_id, selection.end_line, selection.end_line, false, lines)

  -- Move cursor to the first line of inserted text (skip the empty line)
  vim.api.nvim_win_set_cursor(0, { selection.end_line + 2, 0 })

  vim.notify("[DeepL] Translation appended below selected text", vim.log.levels.INFO)
end

return M
