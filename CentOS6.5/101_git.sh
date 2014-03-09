#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

# $1 user.name
# $2 user.email
GIT_USER="$1"
if [ -z "$GIT_USER" ]; then
 echo "GIT_USER?"
 read GIT_USER
fi
GIT_EMAIL="$2"
if [ -z "$GIT_EMAIL" ]; then
 echo "GIT_EMAIL?"
 read GIT_EMAIL
fi

if ! grep name ~/.gitconfig 1> /dev/null 2> /dev/null; then
  git config --global user.name "$GIT_USER"
fi
if ! grep email ~/.gitconfig 1> /dev/null 2> /dev/null; then
  git config --global user.email "$GIT_EMAIL"
fi

if ! grep $GIT_EMAIL ~/.ssh/id_rsa.pub 1> /dev/null 2> /dev/null; then
 ssh-keygen -t rsa -C "$GIT_EMAIL"
 echo ""
 echo "Paste github 'SSH Keys'"
 echo "----------------------------------------------"
 cat ~/.ssh/id_rsa.pub
 echo "----------------------------------------------"
fi

git remote set-url origin https://${GIT_USER}@github.com/ftakao2007/build.git
