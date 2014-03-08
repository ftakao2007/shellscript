#!/bin/sh
# http://qiita.com/hisatake/items/89a1e1c9a3001ba23e92

# $1 SERVER_ADMIN_MAIL="example@gmail.com"
SERVER_ADMIN_MAIL=$2
if [ -z "$SERVER_ADMIN_MAIL" ]; then
  echo "SERVER_ADMIN_MAIL?"
  read SERVER_ADMIN_MAIL
fi

# SERVER_NAME="example.com"
IP_ADDRESS=`ifconfig -a | grep inet | grep -v 127.0.0 | awk '{print $2}' | awk -F':' '{print $2}'`
SERVER_NAME=`host ${IP_ADDRESS} | awk '{print $5}' | sed -e 's/.$//'`

# VHOST_SETTING_PATH="/etc/apache2/sites-available"
VHOST_SETTING_PATH="/etc/apache2/sites-available"

# VHOST="jenkins-server"
VHOST="jenkins-server"

# $2 APACHE_USER="example_user"
APACHE_USER=$1
if [ -z "$APACHE_USER" ]; then
  echo "APACHE_USER?"
  read APACHE_USER
fi

# $3 APACHE_PASSWD="hoge"
APACHE_PASSWD=$3
if [ -z "$APACHE_PASSWD" ]; then
  echo "APACHE_PASSWD?"
  read APACHE_PASSWD
fi

HTPASSWD_FILE="/etc/apache2/.htpasswd"

apt-get install -y jenkins

### later
#if grep '^JAVA_ARGS' /etc/default/jenkins; then

if ! grep 'JAVA_ARGS="-Dfile.encoding=utf-8"' /etc/default/jenkins 1> /dev/null; then
 echo 'JAVA_ARGS="-Dfile.encoding=utf-8"' >> /etc/default/jenkins
fi

### Apache2 setting

cat <<__EOT__ > ${VHOST_SETTING_PATH}/${VHOST}
<VirtualHost *:80>
  ServerAdmin ${SERVER_ADMIN_MAIL}
  ServerName ${SERVER_NAME}

  ProxyPass / http://127.0.0.1:8080/
  ProxyPassReverse / http://127.0.0.1:8080/

  ErrorLog \${APACHE_LOG_DIR}/jenkins-error.log

  # Possible values include: debug, info, notice, warn, error, crit,
  # alert, emerg.
  LogLevel warn

  CustomLog \${APACHE_LOG_DIR}/jenkins-access.log combined

  <Location />
    AuthType Basic
    AuthName "Secret Zone"
    AuthUserFile ${HTPASSWD_FILE}
    require valid-user
  </Location>
</VirtualHost>
__EOT__

# http://www.luft.co.jp/cgi/htpasswd.php
# http://www.kunitake.org/fswiki/static/htpasswd.html
if [ ! -e ${HTPASSWD_FILE} ]; then
 htpasswd -bc ${HTPASSWD_FILE} ${APACHE_USER} ${APACHE_PASSWD}
else
 htpasswd -bn ${HTPASSWD_FILE} ${APACHE_USER} ${APACHE_PASSWD}
fi

a2ensite ${VHOST}
a2dissite default
sudo a2enmod proxy
sudo a2enmod proxy_http
#service jenkins restart 
#service apache2 restart 

# wget -O default.js http://updates.jenkins-ci.org/update-center.json
# sed '1d;$d' default.js > default.json
# mkdir /var/lib/jenkins/updates
# mv default.json /var/lib/jenkins/updates/
# chown -R jenkins:nogroup /var/lib/jenkins/updates
# #service jenkins restart

# http://jenkins-ci.org/stable-rc
cd /usr/share/jenkins/
mv jenkins.war jenkins.war.org
#wget http://updates.jenkins-ci.org/download/war/1.511/jenkins.war
wget http://updates.jenkins-ci.org/download/war/1.532.2/jenkins.war
service jenkins restart
service apache2 restart 

STOP_UPDATE_JENKINS=`dpkg-query --list|grep jenkins | grep -v libjenkins | awk '{print $3}' | sort | uniq`

cat <<__EOT__ > /etc/apt/preferences.d/jenkins
Package: jenkins
Pin: version ${STOP_UPDATE_JENKINS}
Pin-Priority: 99
__EOT__

# http://madroom-project.blogspot.jp/2012/12/ubuntu-1204jenkinsapache80.html
# charactor setting
