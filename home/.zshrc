# If you come from bash you might have to change your $PATH.zsh
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins+=(
    git
    zsh-autosuggestions
    fast-syntax-highlighting
    vi-mode
)

source $ZSH/oh-my-zsh.sh
export PATH="$HOME/scripts:$PATH"

# bindkey for tmux-sessionizer
bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^a "tmux-list\n"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# On-demand rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

# personal function
tm() {
    fish -c "time $*"
}

# personal aliases
alias cl="clear"
alias fe="feh --randomize --bg-fill ~/Pictures/wallpaper/*"
alias vi="nvim"
alias vu10="pactl set-sink-volume @DEFAULT_SINK@ +10%"
alias vd10="pactl set-sink-volume @DEFAULT_SINK@ -10%"
alias vu5="pactl set-sink-volume @DEFAULT_SINK@ +5%"
alias vd5="pactl set-sink-volume @DEFAULT_SINK@ -5%"
alias ccc="clean-clone"

# omz
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="thunar ~/.oh-my-zsh"

# ls
alias ls='lsd'
alias l='ls -lh'
alias ll='ls -lah'
alias la='ls -A'
alias lm='ls -m'
alias lr='ls -R'

# lazygit
alias lg='lazygit'

# git
alias gcl='git clone --depth 1'
alias gtt='git log --graph --oneline --decorate'
alias glp='git log --pretty=format:"%C(yellow)%h%Creset - %C(green)%an%Creset, %ar : %s" --graph'
alias gs='git status'

# bat
alias cat='bat --color=always --line-range :500'

# opengraph-cli
alias og='opengraph-cli'

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
HOMEBREW_NO_AUTO_UPDATE=1

# fzf
source <(fzf --zsh)

DISABLE_FZF_AUTO_COMPLETION="true"
# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}


# zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# docker-completion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# deno
. "/home/himmel/.deno/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go
export PATH=$PATH:$HOME/go/bin # This is to use go application installed with `go install`

# Turso
export PATH="$PATH:/home/himmel/.turso"

# Laravel
export PATH="/home/himmel/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/himmel/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# pomodoro
# Requires https://github.com/caarlos0/timer to be installed. spd-say should ship with your distro

declare -A pomo_options
pomo_options["work"]="45"
pomo_options["break"]="10"

pomodoro () {
  if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
  val=$1
  echo $val | lolcat
  timer ${pomo_options["$val"]}m
  notify-send --app-name=Pomodoro🍅 "'$val' session done 🍅"
  fi
}

alias wo="pomodoro 'work'"
alias br="pomodoro 'break'"

# deno completions
fpath=(~/.completions/ $fpath)
autoload -Uz compinit
compinit -u

# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/himmel/.zsh/completions:"* ]]; then export FPATH="/home/himmel/.zsh/completions:$FPATH"; fi

# pnpm
export PNPM_HOME="/home/himmel/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/himmel/.bun/_bun" ] && source "/home/himmel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$HOME/.local/bin:$PATH

# opencode
export PATH=/home/himmel/.opencode/bin:$PATH

# editor
export EDITOR="nvim"
#compdef opencode
###-begin-opencode-completions-###
#
# yargs command completion script
#
# Installation: opencode completion >> ~/.zshrc
#    or opencode completion >> ~/.zprofile on OSX.
#
_opencode_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _opencode_yargs_completions "$@"
else
  compdef _opencode_yargs_completions opencode
fi
###-end-opencode-completions-###

eval "$(mise activate zsh)"

source ~/.local/bin/fzf-jj.sh
. "$HOME/.cargo/env"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# opencode
alias oc="opencode"

alias lines="cloc . --exclude-dir=node_modules,.next,dist --exclude-ext=yaml"

# Entire CLI shell completion
autoload -Uz compinit && compinit && source <(entire completion zsh)
#compdef tailscale
compdef _tailscale tailscale

# Copyright 2013-2023 The Cobra Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# zsh completion for tailscale                            -*- shell-script -*-

__tailscale_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_tailscale()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __tailscale_debug "\n========= starting completion logic =========="
    __tailscale_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __tailscale_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __tailscale_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., tailscale -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} completion __complete --descs=true --flags=true -- ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __tailscale_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __tailscale_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __tailscale_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __tailscale_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __tailscale_debug "No directive found.  Setting do default"
        directive=0
    fi

    __tailscale_debug "directive: ${directive}"
    __tailscale_debug "completions: ${out}"
    __tailscale_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __tailscale_debug "Completion received error. Ignoring completions."
        return
    fi

    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __tailscale_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __tailscale_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __tailscale_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __tailscale_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __tailscale_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __tailscale_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __tailscale_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __tailscale_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __tailscale_debug "_describe did not find completions."
            __tailscale_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __tailscale_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __tailscale_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_tailscale" ]; then
    _tailscale
fi
