#!/bin/sh

### System wide install (rbenv)
### http://office.tsukuba-bunko.org/ppoi/entry/systemwide-rbenv

### install rbenv
export RBENV_ROOT=/usr/local/rbenv
export PATH=${RBENV_ROOT}/bin:${PATH}


git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT}
git clone git://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build

rbenv init -

cat <<\__EOT__ >> ~/.bashrc
export RBENV_ROOT=/usr/local/rbenv
export PATH=${RBENV_ROOT}/bin:${PATH}
__EOT__

cat <<\__EOT__ >> ~/.profile
export RBENV_ROOT="/usr/local/rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"
__EOT__

#exec ${SHELL} -l
#rbenv install -l
rbenv -v
