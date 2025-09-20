fish_vi_key_bindings

set fish_greeting

eval "$(/opt/homebrew/bin/brew shellenv)"

export XDG_CONFIG_HOME="$HOME/.config"

alias nconf 'nvim ~/.config/nvim'
alias fconf 'nvim ~/.config/fish/config.fish'
alias lg 'lazygit'

alias missing 'python3 ~/dev/_scripts/missing.py'
alias backup 'python3 ~/dev/_scripts/backup.py'
alias archive 'python3 ~/dev/_scripts/archive.py'
alias cleanup 'python3 ~/dev/_scripts/cleanup.py'

zoxide init --cmd cd fish | source

pyenv init - fish | source

set -g -x PIP_REQUIRE_VIRTUALENV true

function auto_activate_venv --on-variable PWD --description "Auto activate/deactivate virtualenv when I change directories"

    # Get the top-level directory of the current Git repo (if any)
    set REPO_ROOT (git rev-parse --show-toplevel 2>/dev/null)

    # Case #1: cd'd from a Git repo to a non-Git folder
    #
    # There's no virtualenv to activate, and we want to deactivate any
    # virtualenv which is already active.
    if test -z "$REPO_ROOT"; and test -n "$VIRTUAL_ENV"
        deactivate
    end

    # Case #2: cd'd folders within the same Git repo
    #
    # The virtualenv for this Git repo is already activated, so there's
    # nothing more to do.
    if [ "$VIRTUAL_ENV" = "$REPO_ROOT/.venv" ]
        return
    end

    # Case #3: cd'd from a non-Git folder into a Git repo
    #
    # If there's a virtualenv in the root of this repo, we should
    # activate it now.
    if [ -d "$REPO_ROOT/.venv" ]
        source "$REPO_ROOT/.venv/bin/activate.fish" &>/dev/null
    end
end
