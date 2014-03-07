#!/bin/sh
# http://qiita.com/hisatake/items/89a1e1c9a3001ba23e92

SERVERADMIN="XXX"
SERVERNAME="XXX"
VHOSTSETTINGPATH="/etc/apache2/sites-available"
VHOST="dtivps-server"
APACHEUSER="tafukui"
APACHEPASSWD="XXX"
HTPASSWDFILE="/etc/apache2/.htpasswd"

apt-get install -y jenkins

### later
#if grep '^JAVA_ARGS' /etc/default/jenkins; then

if ! grep 'JAVA_ARGS="-Dfile.encoding=utf-8"' /etc/default/jenkins 1> /dev/null; then
 echo 'JAVA_ARGS="-Dfile.encoding=utf-8"' >> /etc/default/jenkins
fi

### Apache2 setting

cat <<__EOT__ > ${VHOSTSETTINGPATH}/${VHOST}
<VirtualHost *:80>
  ServerAdmin ${SERVERADMIN}
  ServerName ${SERVERNAME}

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
    AuthUserFile ${HTPASSWDFILE}
    require valid-user
  </Location>
</VirtualHost>
__EOT__

# http://www.luft.co.jp/cgi/htpasswd.php
# http://www.kunitake.org/fswiki/static/htpasswd.html
if [ ! -e ${HTPASSWDFILE} ]; then
 htpasswd -bc ${HTPASSWDFILE} ${APACHEUSER} ${APACHEPASSWD}
else
 htpasswd -bn ${HTPASSWDFILE} ${APACHEUSER} ${APACHEPASSWD}
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

cd /usr/share/jenkins/
mv jenkins.war jenkins.war.org
#wget http://updates.jenkins-ci.org/download/war/1.511/jenkins.war
wget http://updates.jenkins-ci.org/download/war/1.532.2/jenkins.war
service jenkins restart
service apache2 restart 

STOPUPDATEJENKINS=`dpkg-query --list|grep jenkins | grep -v libjenkins | awk '{print $3}' | sort | uniq`

cat <<__EOT__ > /etc/apt/preferences.d/jenkins
Package: jenkins
Pin: version ${STOPUPDATEJENKINS}
Pin-Priority: 99
__EOT__
