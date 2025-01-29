#!/usr/bin/env bash

selection=$(curl -sfL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n" | fzf )
if [[ -n "$selection" ]]; then
    curl -fLw '\n' "https://www.toptal.com/developers/gitignore/api/$(echo "$selection")" >> .gitignore
else
    echo "No selection made."
fi
