# Kitty + Zsh Power Terminal Setup (macOS)

## 1. Install Everything

```bash
# Install Kitty
brew install --cask kitty

# Install modern shell tools
brew install zsh starship fzf zoxide bat eza fd ripgrep

# Install zsh plugin manager (zinit) — use zdharma-continuum org
mkdir -p ~/.local/share/zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
```

---

## 2. Kitty Config (`~/.config/kitty/kitty.conf`)

```conf
# ── Font ──────────────────────────────────────────────
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
font_size        14.0

# ── Window / Layout ──────────────────────────────────
remember_window_size  no
initial_window_width  180c
initial_window_height 45c
window_padding_width  8
hide_window_decorations titlebar-only
confirm_os_window_close 0
enabled_layouts splits, stack

# ── Tabs ─────────────────────────────────────────────
tab_bar_edge            bottom
tab_bar_style           powerline
tab_powerline_style     slanted
tab_title_template      " {index}: {title} "
active_tab_foreground   #1e1e2e
active_tab_background   #cba6f7
inactive_tab_foreground #cdd6f4
inactive_tab_background #313244

# ── Scrollback ───────────────────────────────────────
scrollback_lines 10000

# ── macOS specific ───────────────────────────────────
macos_option_as_alt yes
macos_titlebar_color background

# ── Theme (Catppuccin Mocha) ─────────────────────────
foreground            #CDD6F4
background            #000000
background_opacity    0.8
background_blur       20
selection_foreground  #1E1E2E
selection_background  #F5E0DC
cursor                #F5E0DC
cursor_text_color     #1E1E2E
url_color             #F5E0DC

# black
color0  #45475A
color8  #585B70
# red
color1  #F38BA8
color9  #F38BA8
# green
color2  #A6E3A1
color10 #A6E3A1
# yellow
color3  #F9E2AF
color11 #F9E2AF
# blue
color4  #89B4FA
color12 #89B4FA
# magenta
color5  #F5C2E7
color13 #F5C2E7
# cyan
color6  #94E2D5
color14 #94E2D5
# white
color7  #BAC2DE
color15 #A6ADC8

# ── Keybindings ──────────────────────────────────────
# Tabs
map cmd+t       new_tab_with_cwd
map cmd+w       close_window
map cmd+1       goto_tab 1
map cmd+2       goto_tab 2
map cmd+3       goto_tab 3
map cmd+4       goto_tab 4
map cmd+5       goto_tab 5
map cmd+shift+] next_tab
map cmd+shift+[ previous_tab

# Panes (splits)
map cmd+d       launch --location=vsplit --cwd=current
map cmd+shift+d launch --location=hsplit --cwd=current
map cmd+w       close_window
map cmd+j next_window
map cmd+k previous_window

# Resize panes
map ctrl+shift+left  resize_window narrower 3
map ctrl+shift+right resize_window wider 3
map ctrl+shift+up    resize_window taller 3
map ctrl+shift+down  resize_window shorter 3

# Scrollback
map cmd+k       clear_terminal scrollback active
map cmd+shift+f show_scrollback
```

---

## 3. Install the Nerd Font

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

---

## 4. Zsh Config (`~/.zshrc`)

```zsh
# ── Zinit Plugin Manager ─────────────────────────────
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# ── Plugins ──────────────────────────────────────────
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

autoload -Uz compinit && compinit

zinit light Aloxaf/fzf-tab

bindkey -v
export KEYTIMEOUT=1

# Better vi mode experience
autoload -Uz edit-command-line
zle -N edit-command-line

# Edit current command in full vim with Ctrl+E
bindkey -M vicmd '^e' edit-command-line
bindkey -M viins '^e' edit-command-line

# Keep standard useful bindings in vi insert mode
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line  
bindkey -M viins '^p' up-line-or-history
bindkey -M viins '^n' down-line-or-history
bindkey -M viins '^w' backward-kill-word
bindkey -M viins '^u' backward-kill-line

# Show vi mode indicator in prompt via cursor shape
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'  # block cursor for normal mode
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'  # beam cursor for insert mode
  fi
}
zle -N zle-keymap-select

# Start in insert mode with beam cursor
zle-line-init() { echo -ne '\e[6 q' }
zle -N zle-line-init

# ── FZF Setup (Fuzzy Search) ────────────────────────
source <(fzf --zsh)

# FZF theme (Catppuccin)
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --height=60% --layout=reverse --border=rounded --margin=0,2"

# Use fd for file search
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Ctrl+R = fuzzy search through history
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Press CTRL-Y to copy command, CTRL-/ to toggle preview'"

# ── History ──────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ── Zoxide (smart cd) ───────────────────────────────
eval "$(zoxide init zsh)"

# ── Starship Prompt ──────────────────────────────────
eval "$(starship init zsh)"

# ── Aliases ──────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias cd='z'
alias nv='nvim'
alias ..='cd ..'
alias ...='cd ../..'

# ── PATH & Tools ─────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/mingchungxia/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# nvm (Node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# asdf version manager
. "$(brew --prefix asdf)/libexec/asdf.sh"
```

---

## 5. Starship Prompt (`~/.config/starship.toml`)

```toml
"$schema" = 'https://starship.rs/config-schema.json'

format = """
[](mauve)\
$os\
[](bg:peach fg:mauve)\
$directory\
[](fg:peach bg:green)\
$git_branch\
$git_status\
[](fg:green bg:blue)\
$python\
$nodejs\
$rust\
$golang\
[](fg:blue)\
$fill\
$cmd_duration\
$line_break\
$character"""

palette = 'catppuccin_mocha'

[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo  = "#f2cdcd"
pink      = "#f5c2e7"
mauve     = "#cba6f7"
red       = "#f38ba8"
maroon    = "#eba0ac"
peach     = "#fab387"
yellow    = "#f9e2af"
green     = "#a6e3a1"
teal      = "#94e2d5"
sky       = "#89dceb"
sapphire  = "#74c7ec"
blue      = "#89b4fa"
lavender  = "#b4befe"
text      = "#cdd6f4"
subtext1  = "#bac2de"
overlay0  = "#6c7086"
base      = "#1e1e2e"
mantle    = "#181825"
crust     = "#11111b"

[os]
disabled = false
style = "bg:mauve fg:base"
[os.symbols]
Macos = "  "

[directory]
style = "bg:peach fg:base"
format = "[ $path ]($style)"
truncation_length = 3

[git_branch]
symbol = " "
style = "bg:green fg:base"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:green fg:base"
format = '[$all_status$ahead_behind ]($style)'
conflicted = "=${count} "
ahead = "⇡${count} "
behind = "⇣${count} "
diverged = "⇕⇡${ahead_count}⇣${behind_count} "
untracked = "?${count} "
stashed = "\\${count} "
modified = "!${count} "
staged = "+${count} "
renamed = "»${count} "
deleted = "✘${count} "

[python]
symbol = " "
style = "bg:blue fg:base"
format = '[ $symbol ($version) ]($style)'

[nodejs]
symbol = " "
style = "bg:blue fg:base"
format = '[ $symbol ($version) ]($style)'

[rust]
symbol = "🦀"
style = "bg:blue fg:base"
format = '[ $symbol ($version) ]($style)'

[golang]
symbol = " "
style = "bg:blue fg:base"
format = '[ $symbol ($version) ]($style)'

[fill]
symbol = ' '

[cmd_duration]
min_time = 500
format = '[ 󰔛 $duration](yellow)'

[character]
success_symbol = '[❯](green)'
error_symbol = '[❯](red)'
vimcmd_symbol = '[❮](mauve)'
```

---

## 6. One-Shot Install Script

Save this as `setup.sh` and run it:

```bash
#!/bin/bash
set -e

echo "🚀 Setting up Kitty terminal environment..."

# Homebrew packages
brew install --cask kitty font-jetbrains-mono-nerd-font
brew install zsh starship fzf zoxide bat eza fd ripgrep

# Zinit
if [ ! -d "$HOME/.local/share/zinit" ]; then
  mkdir -p ~/.local/share/zinit
  git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
fi

# Create config dirs
mkdir -p ~/.config/kitty
mkdir -p ~/.config/starship

echo ""
echo "✅ Packages installed!"
echo ""
echo "Now copy the config files:"
echo "  1. kitty.conf   → ~/.config/kitty/kitty.conf"
echo "  2. .zshrc       → ~/.zshrc"
echo "  3. starship.toml → ~/.config/starship.toml"
echo ""
echo "Then restart Kitty and enjoy!"
```

---

## 7. Keybinding Cheat Sheet

| Action | Shortcut |
|---|---|
| New tab | `Cmd+T` |
| Close focused pane/tab | `Cmd+W` |
| Switch tab 1-5 | `Cmd+1` through `Cmd+5` |
| Next/prev tab | `Cmd+Shift+]` / `Cmd+Shift+[` |
| Horizontal split | `Cmd+D` |
| Vertical split | `Cmd+Shift+D` |
| Next/prev pane | `Cmd+J` / `Cmd+K` |
| **Fuzzy history search** | **`Ctrl+R`** |
| Fuzzy file search | `Ctrl+T` |
| Edit command in Vim | `Ctrl+E` |
| Vi normal mode | `Escape` |
| Vi insert mode | `i` |
| Smart cd | `z <partial-path>` |

---

## 8. What You Get

- **Tabs**: Cmd+T, Cmd+1-5, powerline-styled tab bar at bottom
- **Panes**: Cmd+D for splits, vim-style navigation with Cmd+Shift+HJKL
- **Vim bindings in command line**: ESC for normal mode, full vi motions, cursor changes shape to indicate mode, Ctrl+E opens full Vim editor
- **Fuzzy history search**: Ctrl+R with fzf — fast, ranked, with preview
- **Modern CLI replacements**: eza (ls), bat (cat), ripgrep (grep), zoxide (cd), fd (find)
- **Beautiful UI**: Catppuccin Mocha theme across Kitty, fzf, and Starship prompt
- **Autosuggestions**: Ghost text from history as you type (accept with →)
- **Syntax highlighting**: Commands colored as you type (red = bad, green = valid)
