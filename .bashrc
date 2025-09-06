# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi


prompt_command() {
    local real_pwd=$(realpath "$PWD")
    local real_home=$(realpath "$HOME")

    # Replace $HOME with ~ if the path starts with it
    local path="$real_pwd"
    if [[ "$real_pwd" == "$real_home"* ]]; then
        path="~${real_pwd#$real_home}"
    fi

    # Split path by '/'
    local IFS='/'
    read -ra parts <<< "$path"
    local n=${#parts[@]}
    local condensed=""

    if [[ $n -eq 1 && ${parts[0]} == "~" ]]; then
        # In home directory
        condensed="~"
    else
        for ((i=0; i<n-1; i++)); do
            if [[ ${parts[i]} == "~" ]]; then
                condensed+="/~"
            elif [[ -n ${parts[i]} ]]; then
                condensed+="/${parts[i]:0:1}"
            fi
        done
        condensed+="/${parts[n-1]}"
        condensed="${condensed#/}"  # Remove leading slash if present
    fi

    PS1="$condensed > "
}

PROMPT_COMMAND=prompt_command


