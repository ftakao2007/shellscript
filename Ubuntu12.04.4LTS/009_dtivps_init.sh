#!/bin/sh

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

### unable to resolve host
### http://www.plustar.jp/lab/blog/?p=9260
grep "127.0.1.1" /etc/hosts 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo "127.0.1.1 `uname -n`" >> /etc/hosts
fi

### STOP Ajaxterm
### http://kaju.jp/2011/01/post-1508.php
which ajaxterm 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
  apt-get remove ajaxterm
fi

ps -ef | grep -v "grep" | grep "ajaxterm" 1>/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
  ajaxterm_pid=`ps -ef | grep -v "grep" | grep "ajaxterm" | awk '{print $2}'`
  #echo $ajaxterm_pid
  kill -9 $ajaxterm_pid
fi

