#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

which rbenv 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
 echo "Please set rbenv before execute this script."
 exit
fi

if [ "${os_flug}" = "CentOS" ]; then
  ### http://qiita.com/legnoh/items/835ad5d1fa06a333348e
  yum install -y openssl-devel readline-devel zlib-devel curl-devel libyaml-devel
else
  ### http://unicus.jp/skmk/archives/771
  apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev
fi

ruby_version=$1
if [ -z $ruby_version ]; then
  ruby_version=2.1.1
fi

rbenv install $ruby_version
rbenv global $ruby_version

rbenv rehash
