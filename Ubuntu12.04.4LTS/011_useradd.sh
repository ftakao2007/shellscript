#!/bin/sh

# $1 user
user_home="/home/${1}"

useradd -G sudo ${1}
mkdir $user_home
echo " ### input ${1} password ###"
passwd  ${1}

chown -R ${1}:${1} $user_home
