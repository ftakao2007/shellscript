#!/bin/sh

apt-get update
apt-get upgrade
apt-get install -y nkf git dnsutils
# dnsutils -> for host command

# git_user="ftakao2007"
git_user=$1

if [ -z "$git_user" ]; then
 echo "git_user?"
 read git_user
fi 

# git_email="ftakao2007@gmail.com"
git_email=$2
if [ -z "$git_email" ]; then
 echo "git_email?"
 read git_email
fi

# server_user="tafukui"
server_user=$3
if [ -z "$server_user" ]; then
 echo "server_user?"
 read server_user
fi


### DTI VPS setting
./009_dtivps_init.sh

### git setting
./002_git.sh ${git_user} ${git_email}

### server user add
./011_useradd.sh ${server_user}
