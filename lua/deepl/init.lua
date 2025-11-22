local M = {}

local api = require("deepl.api")
local ui = require("deepl.ui")
local utils = require("deepl.utils")

--- Plugin configuration
M.config = {}

--- Initialize the plugin
---@param opts table|nil Configuration options
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Translate text and display/apply the result
---@param target_lang string Target language code (EN, JA, DE, etc.)
---@param mode string|nil Output mode: "float" (default), "replace", or "append"
function M.translate(target_lang, mode)
  mode = mode or "float"

  -- Get text selected in visual mode
  local selection = utils.get_visual_selection()

  if not selection or utils.is_empty(selection.text) then
    utils.error("No text selected. Please select text in visual mode before running this command.")
    utils.clear_visual_marks()
    return
  end

  if utils.is_empty(target_lang) then
    utils.error("Target language not specified. Example: :DeepL EN")
    utils.clear_visual_marks()
    return
  end

  -- Show loading indicator
  local loading_buf, loading_win = ui.show_loading()

  -- Call API to translate
  api.translate(selection.text, target_lang, function(result, error)
    -- Close loading indicator
    ui.close_loading(loading_buf, loading_win)

    -- Clear visual selection marks to prevent reusing old selection
    utils.clear_visual_marks()

    if error then
      utils.error(error)
      return
    end

    if result then
      -- Handle result based on mode
      if mode == "float" then
        -- Display translation result in floating window
        ui.show_translation(result)
      elseif mode == "replace" then
        -- Replace selected text with translation
        require("deepl.editor").replace_text(selection, result)
      elseif mode == "append" then
        -- Append translation after selected text
        require("deepl.editor").append_text(selection, result)
      end
    else
      utils.error("Failed to get translation result")
    end
  end)
end

return M
