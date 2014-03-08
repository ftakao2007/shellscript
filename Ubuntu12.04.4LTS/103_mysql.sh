#!/bin/sh

### http://www.jp-z.jp/changelog/2012-06-25-1.html
apt-get -y install mysql-server mysql-client libmysqld-dev


### Create DB
sql_config="201_mysql_redmine.sql"
mysql_redmine_user="redmine"
mysql_redmine_db="redmine"
if [ -z "$mysql_redmine_db_password" ]; then
  echo "mysql redmine DB password?"
  read mysql_redmine_db_password
fi

# create redmine DB
cat <<__EOT__ > $sql_config
create database $mysql_redmine_db character set utf8
__EOT__
mysql -uroot -p < $sql_config

# add redmine user
cat <<__EOT__ > $sql_config
create user '$mysql_redmine_user'@'localhost' identified by '$mysql_redmine_db_password';
grant all privileges on ${mysql_redmine_db}.* to '$mysql_redmine_user'@'localhost';
__EOT__
mysql -uroot -p < $sql_config

if [ -f "$sql_config" ]; then rm -f $sql_config; fi
