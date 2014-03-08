#!/bin/sh

which rbenv 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
 echo "Please set rbenv before execute this script."
 exit
fi

### http://unicus.jp/skmk/archives/771
apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev

ruby_version=$1
if [ -z $ruby_version ]; then
  ruby_version=2.1.1
fi

rbenv install $ruby_version
rbenv global $ruby_version

rbenv rehash