# Neovim Setup Guide (macOS)

## 1. Install Neovim

```bash
brew install neovim
```

## 2. Install vim-plug (plugin manager)

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## 3. Create the config

```bash
mkdir -p ~/.config/nvim
```

Paste the following into `~/.config/nvim/init.vim`:

```vim
" Enable syntax highlighting
syntax on

" Set tab settings
set tabstop=4
set shiftwidth=4
set expandtab

" Enable filetype detection and indentation
filetype plugin indent on

" Show line numbers
set number

" Plugin management with vim-plug
call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
call plug#end()

" Initialize gitsigns
lua << EOF
require('gitsigns').setup({
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '▎' },
    untracked    = { text = '┆' },
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end
    map('n', ']c', function() gs.nav_hunk('next') end, 'Next hunk')
    map('n', '[c', function() gs.nav_hunk('prev') end, 'Prev hunk')
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
  end
})
EOF
```

## 4. Install the plugins

Open Neovim and run:

```
:PlugInstall
```

Restart Neovim. Done.

## 5. Git Diff Keybindings

| Action | Key |
|---|---|
| Next changed hunk | `]c` |
| Previous changed hunk | `[c` |
| Preview hunk diff | `<leader>hp` |
| Stage hunk | `<leader>hs` |
| Reset hunk | `<leader>hr` |
| Full blame for line | `<leader>hb` |
