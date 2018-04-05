#!/bin/bash

dir=$PWD

# pull in vim color
cd ~

if [ ! -d ".vim/colors" ]; then
  mkdir -p .vim/colors
fi

cd .vim/colors
curl -O https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

# pull down tmux setup
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# copy over dot files
cd $dir
cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases
cp .gitconfig ~/.gitconfig
cp .vimrc ~/.vimrc

# reload bashrc
. ~/.bashrc
