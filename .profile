# ~/.profile: read by login shells (bash, sh, dash) and many desktop
# session managers when starting a graphical session, regardless of shell.

if [ -z "$DOTFILES_PROFILE_LOADED" ]; then
    export DOTFILES_PROFILE_LOADED=1

    export PATH="$HOME/.local/bin:$PATH"

    [ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

    # Machine-specific overrides (not tracked in dotfiles repo)
    [ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
fi

# bash doesn't read .bashrc for login shells automatically - pull it in
# so aliases/prompt/etc. are available in login shells too.
if [ -n "$BASH_VERSION" ] && [ -z "$DOTFILES_BASHRC_LOADED" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
