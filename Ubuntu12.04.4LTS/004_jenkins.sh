#!/bin/sh
# http://qiita.com/hisatake/items/89a1e1c9a3001ba23e92

SERVERADMIN="ftakao2007@gmail.com"
SERVERNAME="v-183-181-14-46.ub-freebit.net"
VHOSTSETTINGPATH="/etc/apache2/sites-available"
VHOST="dtivps-server"

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
    AuthUserFile /etc/apache2/.htpasswd
    require valid-user
  </Location>
</VirtualHost>
__EOT__

a2ensite ${VHOST}
a2dissite default
sudo a2enmod proxy
sudo a2enmod proxy_http
service jenkins restart 
service apache2 restart 
