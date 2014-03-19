#!/bin/sh


if [ ! -e "/etc/rc.d/init.d/jenkins" ]; then
  wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
  rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  yum install jenkins
fi

if ! which java 1> /dev/null
  yum install -y java-1.7.0-openjdk
fi

if [ -e "/etc/sysconfig/jenkins" ]; then
  ARGS=`cat /etc/sysconfig/jenkins | grep JENKINS_ARGS`
  echo $ARGS
  sed -e "s%${ARGS}%JENKINS_ARGS=\"--webroot=/var/run/jenkins/war --httpPort=\$HTTP_PORT --ajp13Port=\$AJP_PORT --prefix=/jenkins\"%" /etc/sysconfig/jenkins
fi

# Apache

service jenkins start
chkconfig jenkins on

