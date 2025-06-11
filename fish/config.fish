fish_vi_key_bindings

set fish_greeting

eval "$(/opt/homebrew/bin/brew shellenv)"

export XDG_CONFIG_HOME="$HOME/.config"

alias nconf 'nvim ~/.config/nvim'
alias fconf 'nvim ~/.config/fish'
alias lg 'lazygit'

zoxide init --cmd cd fish | source

function archive
    if test (count $argv) -eq 0
        echo "Usage: archive <file_or_folder>"
        return 1
    end

    set item $argv[1]
    set archive_dir "_archive"

    if not test -e $item
        echo "Error: '$item' does not exist."
        return 1
    end

    if not test -d $archive_dir
        mkdir $archive_dir
    end

    set timestamp (date +"%Y%m%d%H%M%S")
    set base_name (basename $item)
    set archived_item "$archive_dir/$base_name-$timestamp"

    mv $item $archived_item
    echo "Archived '$item'"
end
