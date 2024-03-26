fish_vi_key_bindings

eval "$(/opt/homebrew/bin/brew shellenv)"

export XDG_CONFIG_HOME="$HOME/.config"

starship init fish | source
zoxide init --cmd cd fish | source
