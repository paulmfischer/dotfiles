#!/usr/bin/env bash
# Bootstraps this machine from the dotfiles repo.
#
# On Linux (incl. WSL): installs GNU Stow if missing, backs up any
# conflicting pre-existing files, then symlinks everything under home/
# into $HOME via stow. Because it's a symlink, future edits to files in
# $HOME are edits to the repo - no separate "copy back" step needed.
#
# On Git Bash / native Windows: symlinks aren't reliably available
# without admin rights, so files are copied instead. Re-run this script
# after pulling repo changes to refresh the copies.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pkg_dir="$repo_dir/home"
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

is_git_bash() {
    [ -n "${MSYSTEM:-}" ]
}

install_stow() {
    if command -v stow >/dev/null 2>&1; then
        return 0
    fi
    echo "GNU Stow not found."
    if command -v apt-get >/dev/null 2>&1; then
        echo "Installing stow via apt-get (requires sudo)..."
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v dnf >/dev/null 2>&1; then
        echo "Installing stow via dnf (requires sudo)..."
        sudo dnf install -y stow
    elif command -v pacman >/dev/null 2>&1; then
        echo "Installing stow via pacman (requires sudo)..."
        sudo pacman -S --noconfirm stow
    elif command -v brew >/dev/null 2>&1; then
        echo "Installing stow via brew..."
        brew install stow
    else
        echo "No supported package manager found (looked for apt-get/dnf/pacman/brew)." >&2
        echo "Install GNU Stow manually and re-run this script." >&2
        return 1
    fi
}

# Move any pre-existing real file out of the way so stow doesn't refuse
# to link over it. Files already symlinked to this repo are left alone.
backup_conflicts() {
    local file rel target
    while IFS= read -r -d '' file; do
        rel="${file#"$pkg_dir"/}"
        target="$HOME/$rel"
        if [ -L "$target" ]; then
            if [ "$(readlink -f "$target")" = "$(readlink -f "$file")" ]; then
                continue
            fi
        fi
        if [ -e "$target" ] || [ -L "$target" ]; then
            mkdir -p "$(dirname "$backup_dir/$rel")"
            echo "Backing up existing $target -> $backup_dir/$rel"
            mv "$target" "$backup_dir/$rel"
        fi
    done < <(find "$pkg_dir" -type f -print0)
}

link_with_stow() {
    backup_conflicts
    stow -d "$repo_dir" -t "$HOME" home
    echo "Linked home/ into \$HOME via stow."
}

copy_fallback() {
    echo "Copying files into \$HOME instead of symlinking."
    local file rel target
    while IFS= read -r -d '' file; do
        rel="${file#"$pkg_dir"/}"
        target="$HOME/$rel"
        mkdir -p "$(dirname "$target")"
        cp "$file" "$target"
    done < <(find "$pkg_dir" -type f -print0)
}

if is_git_bash; then
    echo "Git Bash detected - symlinks aren't reliable here."
    copy_fallback
elif install_stow; then
    link_with_stow
else
    echo "Falling back to copying files instead of symlinking." >&2
    copy_fallback
fi

# vim colorscheme (single file, not worth tracking in the repo itself)
mkdir -p "$HOME/.vim/colors"
curl -sfL -o "$HOME/.vim/colors/gruvbox.vim" \
    https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

# Machine-specific override files - not tracked, created empty/templated
# if they don't already exist so .bashrc/.profile/.gitconfig don't error
# sourcing/including them.
touch "$HOME/.bashrc.local" "$HOME/.profile.local"

if [ ! -f "$HOME/.gitconfig.local" ]; then
    cat > "$HOME/.gitconfig.local" <<'EOF'
[user]
	# Replace with this machine's GPG signing subkey ID
	# (gpg --list-secret-keys --keyid-format=long)
	signingkey = REPLACE_WITH_SIGNING_SUBKEY_ID
EOF
    echo "Created $HOME/.gitconfig.local - edit it with this machine's signing subkey ID."
fi

echo "Setup complete."
