#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

redmine_version="2.4.3"
if [ -z "$mysql_redmine_db_password" ]; then
  echo "mysql redmine DB password?"
  read mysql_redmine_db_password
fi

if [ "${os_flug}" = "CentOS" ]; then
  ### http://qiita.com/legnoh/items/835ad5d1fa06a333348e
  yum install -y openssl-devel readline-devel zlib-devel curl-devel libyaml-devel
  yum install -y ImageMagick ImageMagick-devel
  yum install -y ipa-pgothic-fonts
else
  apt-get install -y make gcc g++ libncurses5-dev libgdbm-dev libssl-dev libyaml-dev libreadline-dev tk-dev zlib1g-dev
  apt-get install -y imagemagick libmagick-dev
  apt-get install -y libmagickwand-dev
fi

### redmine setting
# http://www.redmine.jp/download/
if [ ! -e "redmine-${redmine_version}" ]; then
  wget http://www.redmine.org/releases/redmine-${redmine_version}.tar.gz
  tar zxvf  redmine-${redmine_version}.tar.gz
fi

cd redmine-${redmine_version}

gem install bundler
bundle install --without development test

cat <<__EOT__ > config/database.yml
production:
  adapter: mysql2
  database: redmine
  host: localhost
  username: redmine
  password: $mysql_redmine_db_password
  encoding: utf8
__EOT__

rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data
mkdir public/plugin_assets

ruby script/rails server webrick -e production
