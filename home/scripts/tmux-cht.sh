#!/usr/bin/env bash
set -u

LANG_FILE="$HOME/.tmux-cht-languages"
CMD_FILE="$HOME/.tmux-cht-command"

# POSIX-sh-safe single-quote escaping so URLs with special characters
# (spaces, quotes, &) survive the tmux window command.
sh_quote() {
    printf "'%s'" "${1//\'/\'\\\'\'}"
}

open_cht() {
    local title="$1"
    local url="$2"
    local cmd="curl -s -- $(sh_quote "$url") | less -R"

    if [[ -n "${TMUX:-}" ]]; then
        tmux new-window -n "$title" "$cmd"
    else
        curl -s -- "$url" | less -R
    fi
}

show_topic() {
    local topic="$1"
    local query="$2"
    local url

    if grep -qsFx -- "$topic" "$LANG_FILE"; then
        url="https://cht.sh/$topic/${query// /+}"
    else
        url="https://cht.sh/$topic~${query// /+}"
    fi

    open_cht "cht.sh:$topic" "$url"
}

show_overview() {
    local topic="$1"

    open_cht "cht.sh:$topic" "https://cht.sh/$topic"
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
        --preview='if grep -qsF -- "{2}" '"$LANG_FILE"'; then curl -s "https://cht.sh/{2}/:list"; else curl -s "https://cht.sh/{2}"; fi | head -40' \
        --preview-window='right:60%:wrap' || true
)

[[ -n "${selected:-}" ]] || exit 0

topic="$(awk '{print $2}' <<<"$selected")"

if [[ $selected == '[lang]'* ]]; then
    read -rp "Enter Query: " query || query=""
    query=${query// /+}
    if [[ -n $query ]]; then
        url="https://cht.sh/$topic/$query"
    else
        url="https://cht.sh/$topic"
    fi
else
    read -rp "Enter Query (optional): " query || query=""
    if [[ -n $query ]]; then
        url="https://cht.sh/$topic~${query// /+}"
    else
        url="https://cht.sh/$topic"
    fi
fi

open_cht "cht.sh:$topic" "$url"
