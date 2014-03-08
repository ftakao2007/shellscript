#!/bin/sh

# $1 server_user
server_user="${1}"
if [ -z "$server_user" ]; then
  echo "server_user?"
  read server_user
fi

if ! grep $server_user /etc/passwd 1> /dev/null; then
 server_user_home="/home/${server_user}"
 
 useradd -G sudo ${server_user}
 mkdir $server_user_home
 echo " ### input ${server_user} password ###"
 passwd  ${server_user}
 
 chown -R ${server_user}:${server_user} $server_user_home
else
 echo "${server_user} already exist."
fi