local M = {}

local utils = require("deepl.utils")

--- Determine API base URL based on API key format
--- Free API keys end with ":fx", Pro API keys don't have this suffix
--- See: https://developers.deepl.com/docs/getting-started/auth
---@param api_key string DeepL API key
---@return string API base URL
local function get_api_base_url(api_key)
  if api_key:match(":fx$") then
    return "https://api-free.deepl.com/v2/translate"
  else
    return "https://api.deepl.com/v2/translate"
  end
end

--- Translate text using DeepL API
---@param text string Text to translate
---@param target_lang string Target language code (EN, JA, DE, etc.)
---@param callback function(result: string|nil, error: string|nil) Callback function
function M.translate(text, target_lang, callback)
  local api_key = os.getenv("DEEPL_API_KEY")

  if utils.is_empty(api_key) then
    callback(nil, "DEEPL_API_KEY environment variable is not set")
    return
  end
  ---@cast api_key string

  if utils.is_empty(text) then
    callback(nil, "Text to translate is empty")
    return
  end

  if utils.is_empty(target_lang) then
    callback(nil, "Target language is not specified")
    return
  end

  -- Determine API base URL based on API key format
  local api_base_url = get_api_base_url(api_key)

  -- Escape text
  local escaped_text = text:gsub('"', '\\"'):gsub("\n", "\\n"):gsub("'", "'\\''")

  -- Build curl command
  local curl_cmd = string.format(
    [[curl -s -X POST '%s' \
      -H 'Authorization: DeepL-Auth-Key %s' \
      -H 'Content-Type: application/json' \
      -d '{"text":["%s"],"target_lang":"%s"}']],
    api_base_url,
    api_key,
    escaped_text,
    target_lang:upper()
  )

  -- Call API asynchronously
  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        callback(nil, "API response is empty")
        return
      end

      local response = table.concat(data, "\n")

      -- Try to parse JSON
      local ok, json = pcall(vim.fn.json_decode, response)

      if not ok then
        callback(nil, "Failed to parse JSON: " .. response)
        return
      end

      -- Check for errors
      if json.message then
        callback(nil, "DeepL API error: " .. json.message)
        return
      end

      -- Get translation result
      if json.translations and #json.translations > 0 then
        local translated_text = json.translations[1].text
        callback(translated_text, nil)
      else
        callback(nil, "Failed to get translation result")
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local error_msg = table.concat(data, "\n")
        if error_msg ~= "" then
          callback(nil, "curl error: " .. error_msg)
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        callback(nil, "curl exited with code " .. exit_code)
      end
    end,
  })
end

return M
