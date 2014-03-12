#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

### STOP ipv6
ifconfig -a | grep "inet6" 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
  grep "net.ipv6.conf.all.disable_ipv6" /etc/sysctl.conf 1>/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
  fi

  grep "net.ipv6.conf.default.disable_ipv6" /etc/sysctl.conf 1>/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
  fi

  sysctl -p
fi


if [ "${os_flug}" != "CentOS" ]; then
  ### unable to resolve host (sudo)
  ### http://www.plustar.jp/lab/blog/?p=9260
  grep "127.0.1.1" /etc/hosts 1>/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "127.0.1.1 `uname -n`" >> /etc/hosts
  fi
fi


if [ "${os_flug}" != "CentOS" ]; then
  ### perl: warning: Setting locale failed.
  ### http://qiita.com/d6rkaiz/items/c32f2b4772e25b1ba3ba
  export LANG=en_US.UTF-8
  export LC_ALL=$LANG
  locale-gen --purge $LANG
  dpkg-reconfigure -f noninteractive locales && /usr/sbin/update-locale LANG=$LANG
fi


if [ "${os_flug}" = "CentOS" ]; then
  ### STOP Ajaxterm
  ### http://kaju.jp/2011/01/post-1508.php
  #which ajaxterm 1>/dev/null 2>/dev/null
  #if [ $? -eq 0 ]; then
  if which ajaxterm > /dev/null; then
    apt-get remove -y ajaxterm
  fi
  
  ps -ef | grep -v "grep" | grep "ajaxterm" 1>/dev/null 2>/dev/null
  if [ $? -eq 0 ]; then
    ajaxterm_pid=`ps -ef | grep -v "grep" | grep "ajaxterm" | awk '{print $2}'`
    #echo $ajaxterm_pid
    kill -9 $ajaxterm_pid
  fi

  if grep ajaxterm /etc/passwd > /dev/null; then
    userdel ajaxterm
  fi
fi
