# comment-toggle.nvim

VS Code-style comment toggling for Neovim. Toggles comments on the current line
or visual selection — comments if any line is uncommented, uncomments if all
are commented.

Requires Neovim 0.7+.

## Install

**lazy.nvim**

```lua
{ "weatherwolf/comment-toggle.nvim", config = true }
```

**packer.nvim**

```lua
use { "weatherwolf/comment-toggle.nvim", config = function() require("comment_toggle").setup() end }
```

## Configuration

All options are optional:

```lua
require("comment_toggle").setup({
  keymap = "<leader>?",  -- set to `false` to disable
  comments = {           -- per-filetype markers (extends defaults)
    rust = "//",
    haskell = "--",
  },
})
```

Built-in filetypes: `lua`, `python`, `sql`, `vim`, `sh`/`bash`/`zsh`, `ruby`,
`yaml`, `toml`, `conf`, `make`, `dockerfile`. Anything else falls back to `//`.

## Usage

| Command          | Action                                 |
| ---------------- | -------------------------------------- |
| `:ToggleComment` | Smart toggle (default `<leader>?`)     |
| `:CommentOut`    | Force-comment the range                |
| `:Uncomment`     | Force-uncomment the range              |

All commands accept a range and work in normal or visual mode.

## License

MIT
