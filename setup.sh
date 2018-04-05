#!/bin/bash

#copy over dot files
cp .bashrc ~/.bashrc
cp .bash_aliases ~/.bash_aliases
cp .gitconfig ~/.gitconfig

# reload bashrc
. ~/.bashrc
