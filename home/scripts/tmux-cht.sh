#!/usr/bin/env bash

LANG_FILE="$HOME/.tmux-cht-languages"
CMD_FILE="$HOME/.tmux-cht-command"

show_topic() {
    local topic="$1"
    local query="$2"
    local url

    if grep -q "$topic" "$LANG_FILE"; then
        url="https://cht.sh/$topic/${query// /+}"
    else
        url="https://cht.sh/$topic~${query// /+}"
    fi

    if [[ -n $TMUX ]]; then
        tmux neww bash -c "curl -s \"$url\" | less -R"
    else
        curl -s "$url" | less -R
    fi
}

show_overview() {
    local topic="$1"
    local url="https://cht.sh/$topic"

    if [[ -n $TMUX ]]; then
        tmux neww bash -c "curl -s \"$url\" | less -R"
    else
        curl -s "$url" | less -R
    fi
}

if [[ $# -eq 1 ]]; then
    show_overview "$1"
    exit 0
fi

if [[ $# -ge 2 ]]; then
    topic="$1"
    shift
    show_topic "$topic" "$*"
    exit 0
fi

if [[ ! -f $LANG_FILE ]] || [[ ! -f $CMD_FILE ]]; then
    echo "cht.sh: missing ~/.tmux-cht-languages or ~/.tmux-cht-command" >&2
    exit 1
fi

selected=$(
    {
        sed 's/^/[lang] /' "$LANG_FILE"
        sed 's/^/[cmd] /' "$CMD_FILE"
    } | sort -k2 | \
    fzf --prompt="cht.sh > " \
        --header="Select a topic" \
        --delimiter=' ' \
        --with-nth='2..' \
        --preview='if grep -qs "{2}" '"$LANG_FILE"'; then curl -s "https://cht.sh/{2}/:list"; else curl -s "https://cht.sh/{2}"; fi | head -40' \
        --preview-window='right:60%:wrap'
)

[[ -z $selected ]] && exit 0

topic=$(echo "$selected" | awk '{print $2}')

if echo "$selected" | grep -q '^\[lang\]'; then
    read -p "Enter Query: " query
    query=${query// /+}
    if [[ -n $query ]]; then
        url="https://cht.sh/$topic/$query"
    else
        url="https://cht.sh/$topic"
    fi
else
    read -p "Enter Query (optional): " query
    if [[ -n $query ]]; then
        url="https://cht.sh/$topic~${query// /+}"
    else
        url="https://cht.sh/$topic"
    fi
fi

if [[ -n $TMUX ]]; then
    tmux neww bash -c "curl -s \"$url\" | less -R"
else
    curl -s "$url" | less -R
fi
