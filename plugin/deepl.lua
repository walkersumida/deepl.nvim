-- Exit if the plugin is already loaded
if vim.g.loaded_deepl then
  return
end
vim.g.loaded_deepl = 1

-- Register DeepL command
vim.api.nvim_create_user_command("DeepL", function(opts)
  -- Parse arguments: <target_lang> [--mode=<mode>]
  local args = opts.args
  local target_lang = ""
  local mode = "float" -- default mode

  -- Extract mode if specified
  local mode_pattern = "%s*%-%-mode=(%w+)"
  local mode_match = args:match(mode_pattern)
  if mode_match then
    mode = mode_match
    -- Remove --mode=<mode> from args to get target_lang
    target_lang = args:gsub(mode_pattern, ""):match("^%s*(.-)%s*$")
  else
    target_lang = args:match("^%s*(.-)%s*$")
  end

  -- Validate target language
  if target_lang == "" then
    vim.notify(
      "[DeepL] Please specify target language. Example: :DeepL EN [--mode=float|replace|append]",
      vim.log.levels.ERROR
    )
    require("deepl.utils").clear_visual_marks()
    return
  end

  -- Validate mode
  if mode ~= "float" and mode ~= "replace" and mode ~= "append" then
    vim.notify("[DeepL] Invalid mode: " .. mode .. ". Use: float, replace, or append", vim.log.levels.ERROR)
    require("deepl.utils").clear_visual_marks()
    return
  end

  require("deepl").translate(target_lang, mode)
end, {
  nargs = "+",
  range = true,
  desc = "Translate selected text with DeepL",
})
