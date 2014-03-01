#!/bin/sh

git_user="ftakao2007"
git_email="ftakao2007@gmail.com"
server_user="tafukui"

apt-get update
apt-get upgrade

apt-get install nkf git

### DTI VPS setting
./009_dtivps_init.sh

### git setting
./002_git.sh ${git_user} ${git_email}

### server user add
./011_useradd.sh ${server_user}
