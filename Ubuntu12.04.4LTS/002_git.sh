#!/bin/sh

# $1 user.name
# $2 user.email

git config --global user.name "$1"
git config --global user.email "$2"

ssh-keygen -t rsa -C "$2"

echo ""
echo "Paste github 'SSH Keys'"
echo "----------------------------------------------"
cat ~/.ssh/id_rsa.pub
echo "----------------------------------------------"
