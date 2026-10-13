#!/usr/bin/env bash

# Shared collector for globally installed JS packages (bun, npm, pnpm).
#
# This file is sourced, not executed: ./snapshot writes the collected state to
# runs/js/globals.list and runs/js/install diffs against it.
#
# Prints one "<manager>|<package>|<version>" line per global package. Version
# is "*" when the manager does not report one.

# Packages that ship with the runtime: reinstalling them would fight the
# node/pnpm install that brought them in.
js_skip() {
    case "$1|$2" in
        'npm|npm' | 'npm|corepack' | 'npm|command-code' | 'pnpm|pnpm') return 0 ;;
        *) return 1 ;;
    esac
}

# "<name>@<version>" -> "<name>|<version>". Handles scoped names (@scope/name),
# where the leading @ must not be mistaken for the version separator.
js_split_spec() {
    local spec="$1" name version

    case "$spec" in
        @*/*@*)
            name="${spec%@*}"
            version="${spec##*@}"
            ;;
        @*/*)
            name="$spec"
            version=""
            ;;
        *@*)
            name="${spec%@*}"
            version="${spec##*@}"
            ;;
        *)
            name="$spec"
            version=""
            ;;
    esac

    [[ -z "$name" ]] && return 0

    printf '%s|%s\n' "$name" "${version:-*}"
}

# Prepends the runtime bin dirs this script's own managers live in.
#
# restore runs every step in a child process, and .zshrc is only stowed (never
# sourced) during a restore, so the paths .zshrc normally adds are absent here:
# runs/yay/node installs bun/nvm into ~/.bun and ~/.config/nvm, and mise only
# exposes shims once `mise install` has run. Without this, ./run js would find
# no managers at all on a fresh machine and silently skip every package.
js_runtime_path() {
    local home_dir="${1:-$HOME}"
    local nvm_node nvm_bin

    PATH="$home_dir/.bun/bin:$PATH"
    if [[ -d "$home_dir/.config/nvm/versions/node" ]]; then
        nvm_node="$(ls -1 "$home_dir/.config/nvm/versions/node" 2>/dev/null | sort -V | tail -1)"
        if [[ -n "$nvm_node" ]]; then
            nvm_bin="$home_dir/.config/nvm/versions/node/$nvm_node/bin"
            [[ -d "$nvm_bin" ]] && PATH="$nvm_bin:$PATH"
        fi
    fi
    PATH="$home_dir/.local/share/pnpm:$PATH"
    PATH="$home_dir/.local/share/mise/shims:$PATH"
    export PATH

    export BUN_INSTALL="${BUN_INSTALL:-$home_dir/.bun}"
    export PNPM_HOME="${PNPM_HOME:-$home_dir/.local/share/pnpm}"
}

# Reads "<manager> ls -g --json" output on stdin and prints "name|version".
# Handles both shapes seen in the wild:
#   npm  -> [{"name": ..., "version": ...}, ...]        (npm 11+ / vp npm)
#   npm  -> {"dependencies": {"<name>": {"version": ...}}} (npm 9/10)
#   pnpm -> [{"path": ..., "dependencies": {"<name>": {"version": ...}}}]
#
# Unparseable output is reported on stderr rather than treated as "no packages",
# so a broken/older manager shows up as a warning instead of silently emptying
# globals.list on the next ./snapshot. Exits 0 either way to keep the pipeline
# (and the caller) alive; stderr is not redirected away by the callers.
js_json_to_specs() {
    local manager="${1:-js}"
    JS_JSON_MANAGER="$manager" node -e '
const manager = process.env.JS_JSON_MANAGER || "js";
let raw = "";
process.stdin.on("data", (d) => (raw += d));
process.stdin.on("end", () => {
    if (!raw.trim()) process.exit(0);
    let data;
    try {
        data = JSON.parse(raw);
    } catch (err) {
        process.stderr.write(`${manager}: could not parse global list as JSON (${err.message}); reporting no packages for this manager\n`);
        process.exit(0);
    }
    const out = new Set();
    const walk = (node) => {
        if (!node || typeof node !== "object") return;
        if (Array.isArray(node)) {
            if (!node.length) process.stderr.write(`${manager}: global list is empty (no global packages)\n`);
            return node.forEach(walk);
        }
        if (typeof node.name === "string" && typeof node.version === "string") {
            out.add(node.name + "@" + node.version);
        }
        let sawDeps = false;
        for (const key of ["dependencies", "devDependencies", "optionalDependencies"]) {
            const deps = node[key];
            if (!deps || typeof deps !== "object") continue;
            sawDeps = true;
            for (const [name, meta] of Object.entries(deps)) {
                const version = typeof meta === "string" ? meta : meta && meta.version;
                if (typeof version !== "string" || !version) continue;
                out.add(name + "@" + version.replace(/^[\^~>=<\s]+/, ""));
            }
        }
        if (!sawDeps) {
            process.stderr.write(`${manager}: global list has no dependencies field (unexpected npm/pnpm output shape)\n`);
        }
    };
    walk(data);
    for (const spec of out) console.log(spec);
});
'
}

# Usage: js_collect_globals <home_dir>
js_collect_globals() {
    local home_dir="${1:-$HOME}"
    local have_node="false"

    # Managers are looked up through the runtimes this machine installs, not
    # only through the inherited PATH (see js_runtime_path).
    js_runtime_path "$home_dir"

    command -v node > /dev/null 2>&1 && have_node="true"

    if command -v bun > /dev/null 2>&1; then
        # bun resolves its global dir from BUN_INSTALL, which is only exported
        # by the interactive shell, so fall back to the conventional location.
        bun pm ls -g 2>/dev/null \
            | sed -e 's/^[│├└─[:space:]]*//' -e 's/[[:space:]]*$//' \
            | grep '@' \
            | while IFS= read -r spec; do
                js_split_spec "$spec"
            done \
            | while IFS='|' read -r pkg version; do
                js_skip bun "$pkg" && continue
                printf 'bun|%s|%s\n' "$pkg" "$version"
            done || true
    fi

    # npm and pnpm only expose their global list as JSON, and node is what
    # reads it, so without node there is nothing to report.
    if [[ "$have_node" == "true" ]] && command -v npm > /dev/null 2>&1; then
        # stderr is kept so js_json_to_specs' parse/shape warnings reach the
        # user; only npm's own noise is dropped.
        npm ls -g --depth=0 --json 2>/dev/null \
            | js_json_to_specs npm \
            | while IFS= read -r spec; do
                js_split_spec "$spec"
            done \
            | while IFS='|' read -r pkg version; do
                js_skip npm "$pkg" && continue
                printf 'npm|%s|%s\n' "$pkg" "$version"
            done || true
    fi

    if [[ "$have_node" == "true" ]] && command -v pnpm > /dev/null 2>&1; then
        pnpm ls -g --depth=0 --json 2>/dev/null \
            | js_json_to_specs pnpm \
            | while IFS= read -r spec; do
                js_split_spec "$spec"
            done \
            | while IFS='|' read -r pkg version; do
                js_skip pnpm "$pkg" && continue
                printf 'pnpm|%s|%s\n' "$pkg" "$version"
            done || true
    fi
}
