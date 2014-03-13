#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

if [ "${os_flug}" = "CentOS" ]; then
  yum install -y httpd httpd-devel
else
  # apache2     : jenkins
  # apache2-dev : redmine
  apt-get install -y apache2 apache2-dev
fi
