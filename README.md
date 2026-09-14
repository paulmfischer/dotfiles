# dotfiles
Some configuration files I have used across machines.

## Usage

```sh
git clone <repo-url> ~/projects/dotfiles
cd ~/projects/dotfiles
./setup.sh
```

Files tracked under `home/` mirror their layout in `$HOME` (a GNU Stow
package). On Linux/WSL, `setup.sh` installs Stow if needed and symlinks
`home/*` into `$HOME`, so future edits to files in `$HOME` are edits to
the repo directly. On Git Bash/native Windows, files are copied instead
since symlinks aren't reliably available there - re-run `setup.sh`
after pulling changes to refresh the copies.

Machine-specific values live in untracked override files, created
automatically by `setup.sh` if missing:
- `~/.bashrc.local`, `~/.profile.local` - sourced at the end of
  `.bashrc`/`.profile` if present.
- `~/.gitconfig.local` - included by `.gitconfig`; put this machine's
  GPG signing subkey ID here (`gpg --list-secret-keys --keyid-format=long`).
