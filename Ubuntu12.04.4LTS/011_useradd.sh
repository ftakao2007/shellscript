#!/bin/sh

# $1 user
user_home="/home/${1}"

useradd -G sudo ${1}
mkdir $user_home
passwd  ${1}

git clone https://github.com/ftakao2007/vim.git
cp vim/.vimrc $user_home
cp .bashrc $user_home

chown -R ${1}:${1} $user_home
