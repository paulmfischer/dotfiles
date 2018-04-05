#!/bin/bash

# pull in vim color
dir=$PWD
echo $dir
cd ~
mkdir .vim
cd .vim
mkdir colors
cd colors
curl -O https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim
cd $dir

# copy over dot files
cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases
cp .gitconfig ~/.gitconfig
cp .vimrc ~/.vimrc

# reload bashrc
. ~/.bashrc
