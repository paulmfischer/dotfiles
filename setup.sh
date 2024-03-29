#!/bin/bash

dir=$PWD

# pull in vim color
echo "pull in gruvbox.vim color"
cd ~

if [ ! -d ".vim/colors" ]; then
  mkdir -p .vim/colors
fi

cd .vim/colors
curl -O https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim


# copy over dot files
cd $dir
# cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases
cp .gitconfig ~/.gitconfig
cp .vimrc ~/.vimrc

# change diff/merge tool to work with beyond compare 3 properly in linux
if [ "$1" = "nix" ]; then
  # pull down tmux setup if it doesn't exist
  if [ ! -f "~/.tmux.conf" ]; then
    echo ".tmux.conf does not exist, pulling down config"
    cd ~
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
  fi

  git config --global core.editor vim
  git config --global diff.tool bc3
  git config --global --unset difftool.bc3.path
  git config --global difftool.bc3.trustExitCode true
  git config --global merge.tool bc3
  git config --global --unset mergetool.bc3.path
  git config --global mergetool.bc3.trustExitCode true
fi

# reload bashrc
. ~/.bashrc
