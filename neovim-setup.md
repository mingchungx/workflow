# Neovim Setup Guide (macOS) — NvChad

## 1. Install Neovim

```bash
brew install neovim
```

## 2. Clean any existing config

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.vim/plugged
```

## 3. Install NvChad

```bash
git clone https://github.com/NvChad/starter ~/.config/nvim
```

Open Neovim and wait for lazy.nvim to auto-install all plugins:

```bash
nvim
```

Restart Neovim once it finishes.

## 4. Enable git blame

Add this to `~/.config/nvim/lua/plugins/init.lua`:

```lua
{
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
  },
}
```

## 5. What You Get

NvChad comes with gitsigns built in. Out of the box:

- **Git diff signs in the gutter** — green for added, blue for changed, red for deleted
- **Inline git blame** on the current line (after step 4)
- Syntax highlighting, file tree, fuzzy finder, LSP support, auto-completion, and more

## 6. Key Keybindings

| Action | Key |
|---|---|
| Next changed hunk | `]c` |
| Previous changed hunk | `[c` |
| Preview hunk diff | `<leader>hp` |
| Stage hunk | `<leader>hs` |
| Reset hunk | `<leader>hr` |
| Toggle git blame | `<leader>gb` |
| Open file tree | `<leader>e` |
| Find files | `<leader>ff` |
| Live grep | `<leader>fw` |
| Theme picker | `<leader>th` |

`<leader>` is `Space` by default in NvChad.
