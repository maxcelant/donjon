#!/bin/sh
set -eu

repo=${DONJON_REPO:-maxcelant/donjon}
ref=${DONJON_VERSION:-main}
install_dir=${DONJON_INSTALL_DIR:-"$HOME/.local/bin"}
config=${DONJON_CONFIG:-"$HOME/.donjon/config.yaml"}
config_dir=$(dirname "$config")
url="https://raw.githubusercontent.com/$repo/$ref/donjon"

command -v curl >/dev/null 2>&1 || {
    echo "donjon: curl is required" >&2
    exit 1
}
command -v python3 >/dev/null 2>&1 || {
    echo "donjon: Python 3 is required" >&2
    exit 1
}

mkdir -p "$install_dir" "$config_dir"
temporary=$(mktemp "$install_dir/.donjon.XXXXXX")
trap 'rm -f "$temporary"' EXIT HUP INT TERM

curl -fsSL "$url" -o "$temporary"
chmod 755 "$temporary"
mv "$temporary" "$install_dir/donjon"
trap - EXIT HUP INT TERM

if [ ! -e "$config" ]; then
    cat >"$config" <<'EOF'
defaultHarness: "pi"

pi:
  path: ""
  sessionDir: ""

claude:
  path: ""
  sessionDir: ""

codex:
  path: ""
  sessionDir: ""

tools:
  fzf:
    path: ""
EOF
    chmod 600 "$config"
fi

printf 'Installed donjon to %s\n' "$install_dir/donjon"
printf 'Configuration: %s\n' "$config"
case ":$PATH:" in
    *":$install_dir:"*) ;;
    *) printf 'Add %s to your PATH.\n' "$install_dir" ;;
esac
