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

# Reads "<manager> ls -g --json" output on stdin and prints "name|version".
# Handles both shapes seen in the wild:
#   npm  -> [{"name": ..., "version": ...}, ...]        (npm 11+ / vp npm)
#   npm  -> {"dependencies": {"<name>": {"version": ...}}} (npm 9/10)
#   pnpm -> [{"path": ..., "dependencies": {"<name>": {"version": ...}}}]
js_json_to_specs() {
    node -e '
let raw = "";
process.stdin.on("data", (d) => (raw += d));
process.stdin.on("end", () => {
    let data;
    try {
        data = JSON.parse(raw);
    } catch {
        process.exit(0);
    }
    const out = new Set();
    const walk = (node) => {
        if (!node || typeof node !== "object") return;
        if (Array.isArray(node)) return node.forEach(walk);
        if (typeof node.name === "string" && typeof node.version === "string") {
            out.add(node.name + "@" + node.version);
        }
        for (const key of ["dependencies", "devDependencies", "optionalDependencies"]) {
            const deps = node[key];
            if (!deps || typeof deps !== "object") continue;
            for (const [name, meta] of Object.entries(deps)) {
                const version = typeof meta === "string" ? meta : meta && meta.version;
                if (typeof version !== "string" || !version) continue;
                out.add(name + "@" + version.replace(/^[\^~>=<\s]+/, ""));
            }
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

    command -v node > /dev/null 2>&1 && have_node="true"

    if command -v bun > /dev/null 2>&1; then
        # bun resolves its global dir from BUN_INSTALL, which is only exported
        # by the interactive shell, so fall back to the conventional location.
        BUN_INSTALL="${BUN_INSTALL:-$home_dir/.bun}" bun pm ls -g 2>/dev/null \
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
        npm ls -g --depth=0 --json 2>/dev/null \
            | js_json_to_specs \
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
            | js_json_to_specs \
            | while IFS= read -r spec; do
                js_split_spec "$spec"
            done \
            | while IFS='|' read -r pkg version; do
                js_skip pnpm "$pkg" && continue
                printf 'pnpm|%s|%s\n' "$pkg" "$version"
            done || true
    fi
}
