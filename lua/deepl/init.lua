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

--- Translate text and display the result
---@param target_lang string Target language code (EN, JA, DE, etc.)
function M.translate(target_lang)
  -- Get text selected in visual mode
  local text = utils.get_visual_selection()

  if utils.is_empty(text) then
    utils.error("No text selected. Please select text in visual mode before running this command.")
    return
  end

  if utils.is_empty(target_lang) then
    utils.error("Target language not specified. Example: :DeepL EN")
    return
  end

  -- Show loading indicator
  local loading_buf, loading_win = ui.show_loading()

  -- Call API to translate
  api.translate(text, target_lang, function(result, error)
    -- Close loading indicator
    ui.close_loading(loading_buf, loading_win)

    if error then
      utils.error(error)
      return
    end

    if result then
      -- Display translation result in floating window
      ui.show_translation(result, text)
    else
      utils.error("Failed to get translation result")
    end
  end)
end

return M
