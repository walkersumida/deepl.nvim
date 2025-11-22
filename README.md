# 🌐 deepl.nvim

A Neovim plugin that translates text using the DeepL API with multiple output modes (float, replace, append).

![Neovim](https://img.shields.io/badge/Neovim-0.7+-green.svg)
![Lua](https://img.shields.io/badge/Lua-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

<table>
  <tr>
    <th>Float Mode</th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/d9ac9c90-2533-4fda-836a-bba4d05cfb64" />
    </td>
  </tr>
  <tr>
    <th>Replace Mode</th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/2be6747d-e12e-4065-af46-6ced9c0077f0" />
    </td>
  </tr>
  <tr>
    <th>Append Mode</th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/8ac3999e-1eb3-40be-8cc4-e7a6388dcfaf" />
    </td>
  </tr>
</table>

## ✨ Features

- Translate text selected in visual mode using the DeepL API
- Multiple output modes:
  - **Float mode**: Display translation results in a floating window
  - **Replace mode**: Replace selected text with translation
  - **Append mode**: Append translation below selected text
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

### Basic Usage

1. Select text in visual mode
2. Run the `:DeepL <language_code> [--mode=<mode>]` command

### Output Modes

The plugin supports three output modes:

- **`float`** (default): Display translation in a floating window
- **`replace`**: Replace selected text with translation
- **`append`**: Append translation below selected text (with an empty line)

### Examples

```vim
" Display translation in floating window (default)
:DeepL EN
:DeepL EN --mode=float

" Replace selected text with translation
:DeepL JA --mode=replace

" Append translation below selected text
:DeepL DE --mode=append
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
-- Translate to English (floating window)
vim.keymap.set('v', '<leader>te', ':DeepL EN<CR>', { desc = 'Translate to English' })

-- Translate to Japanese (floating window)
vim.keymap.set('v', '<leader>tj', ':DeepL JA<CR>', { desc = 'Translate to Japanese' })

-- Replace with English translation
vim.keymap.set('v', '<leader>tre', ':DeepL EN --mode=replace<CR>', { desc = 'Replace with English translation' })

-- Replace with Japanese translation
vim.keymap.set('v', '<leader>trj', ':DeepL JA --mode=replace<CR>', { desc = 'Replace with Japanese translation' })

-- Append English translation below
vim.keymap.set('v', '<leader>tae', ':DeepL EN --mode=append<CR>', { desc = 'Append English translation below' })

-- Append Japanese translation below
vim.keymap.set('v', '<leader>taj', ':DeepL JA --mode=append<CR>', { desc = 'Append Japanese translation below' })
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
