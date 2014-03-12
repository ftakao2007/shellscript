#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

### python
# about python3.4
# http://pelican.aodag.jp/python34noensurepipsoretopyvenvnogeng-xin.html

if [ "${os_flug}" = "CentOS" ]; then
  yum groupinstall -y "Development tools"
  yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
fi

## python2.7.6
if ! ls /usr/local/bin/python2.7 1> /dev/null 2> /dev/null; then
  #curl -O http://python.org/ftp/python/2.7.6/Python-2.7.6.tgz
  wget http://python.org/ftp/python/2.7.6/Python-2.7.6.tgz
  tar zxf Python-2.7.6.tgz 
  cd Python-2.7.6
  ### default python setting option "--enable-shared"
  ### ./configure --prefix=/usr/local --enable-shared
  ./configure --prefix=/usr/local
  make && make altinstall
  cd ..
fi

## python3.4.0
if ! ls /usr/local/bin/python3.4 1> /dev/null 2> /dev/null; then
  #curl -O http://python.org/ftp/python/3.3.3/Python-3.3.3.tgz
  wget http://python.org/ftp/python/3.4.0/Python-3.4.0rc3.tgz
  tar zxf Python-3.4.0rc3.tgz 
  cd Python-3.4.0rc3.tgz
  ### default python setting option "--enable-shared"
  ### ./configure --prefix=/usr/local --enable-shared
  ./configure --prefix=/usr/local
  make && make altinstall
  cd ..
fi

### pip
# http://qiita.com/a_yasui/items/5f453297855791ed648d
if ! which pip 1> /dev/null; then
  # curl -kL https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python
  wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
  python get-pip.py
fi

### virtualenv
if ! which virtualenv 1> /dev/null; then
  pip install virtualenv
fi

if ! grep VIRTUALENV_USE_DISTRIBUTE ~/.bashrc 1> /dev/null; then
cat <<\__EOT__ >> ~/.bashrc
export VIRTUALENV_USE_DISTRIBUTE=true
__EOT__
fi


### virtualenvwrapper
if ! which virtualenvwrapper.sh 1> /dev/null; then
  pip install virtualenvwrapper
fi

if ! grep WORKON_HOME ~/.bashrc 1> /dev/null; then
cat <<\__EOT__ >> ~/.bashrc
export WORKON_HOME=$HOME/.virtualenvs
__EOT__
fi

if ! grep 'source /usr/bin/virtualenvwrapper.sh' ~/.bashrc 1> /dev/null; then
cat <<\__EOT__ >> ~/.bashrc
source /usr/bin/virtualenvwrapper.sh
__EOT__
fi

### How to use virtualenv
## pip
# pip freeze
## virtualenv
# mkvirtualenv (newenv)
# workon (newenv)
# workon
# deactivate
# rmvirtualenv (newenv)
## Advance
# mkvirtualenv --python=/usr/local/bin/python2.7 python2.7.6-fabric
