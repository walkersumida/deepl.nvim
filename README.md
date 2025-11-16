# 🌐 deepl.nvim

A Neovim plugin that translates text using the DeepL API and displays the results in a floating window.

![Neovim](https://img.shields.io/badge/Neovim-0.7+-green.svg)
![Lua](https://img.shields.io/badge/Lua-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

<table>
  <tr>
    <th>DeepL Translation</th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/8bcbc8cc-d022-48e8-8034-e053a026677e" />
    </td>
  </tr>
</table>

## ✨ Features

- Translate text selected in visual mode using the DeepL API
- Display translation results in a floating window
- User-specified target language
- Simple and lightweight implementation

## 📋 Requirements

- Neovim 0.7.0 or higher
- DeepL API key (free or paid plan)
- `curl` command

## 📦 Installation

### lazy.nvim

```lua
{
  "walkersumida/deepl.nvim",
  version = "*",
  opts = {},
}
```

### packer.nvim

```lua
use {
  "walkersumida/deepl.nvim",
  config = function()
    require('deepl').setup()
  end,
}
```

### vim-plug

```vim
Plug "walkersumida/deepl.nvim"
```

## ⚙️ Configuration

### DeepL API Key

Set your DeepL API key in the `DEEPL_API_KEY` environment variable.

```bash
export DEEPL_API_KEY="your-api-key-here"
```

You can make this persistent by adding it to your shell configuration file (`.bashrc`, `.zshrc`, etc.).

### Plugin Initialization

Add the following to your `init.lua` or `init.vim`:

```lua
require('deepl').setup()
```

Currently, there are no configuration options, but they may be added in the future.

## 🚀 Usage

1. Select text in visual mode
2. Run the `:DeepL <language_code>` command

### Examples

```vim
" Translate to English
:DeepL EN

" Translate to Japanese
:DeepL JA

" Translate to German
:DeepL DE
```

### Supported Languages

Examples of language codes:

- `EN` - English
- `JA` - Japanese
- `DE` - German
- `FR` - French
- `ES` - Spanish
- `IT` - Italian
- `NL` - Dutch
- `PL` - Polish
- `PT` - Portuguese
- `RU` - Russian
- `ZH` - Chinese
- `KO` - Korean

For a complete list of supported languages, see the [DeepL API documentation](https://developers.deepl.com/docs/getting-started/supported-languages).

## ⌨️ Keybinding Examples

Example keybindings for convenience:

```lua
-- Translate to English
vim.keymap.set('v', '<leader>te', ':DeepL EN<CR>', { desc = 'Translate to English' })

-- Translate to Japanese
vim.keymap.set('v', '<leader>tj', ':DeepL JA<CR>', { desc = 'Translate to Japanese' })
```

## 🎮 Floating Window Controls

When the translation result floating window is displayed:

- Press `q` or `ESC` to close

## 🔧 Troubleshooting

### API Key Error

```
DEEPL_API_KEY environment variable is not set
```

→ Check that the `DEEPL_API_KEY` environment variable is set.

### curl Error

```
curl error: ...
```

→ Check that the `curl` command is installed.

### JSON Parse Error

The DeepL API response may be incorrect. Check that your API key is valid.

## 📚 References

- [DeepL API Documentation](https://www.deepl.com/docs-api)

## ⭐ Show your support

Give a ⭐️ if this project helped you! Thank you!
