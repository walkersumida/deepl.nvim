-- Exit if the plugin is already loaded
if vim.g.loaded_deepl then
  return
end
vim.g.loaded_deepl = 1

-- Register DeepL command
vim.api.nvim_create_user_command("DeepL", function(opts)
  -- Get target language from arguments
  local target_lang = opts.args

  if target_lang == "" then
    vim.notify("[DeepL] Please specify target language. Example: :DeepL EN", vim.log.levels.ERROR)
    return
  end

  require("deepl").translate(target_lang)
end, {
  nargs = 1,
  range = true,
  desc = "Translate selected text with DeepL",
})
