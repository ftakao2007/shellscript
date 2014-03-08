#!/bin/sh

cat << __EOT__
input number
0) init only
1) with jenkins
__EOT__
read install_flg

# case num in
#   1) install_flg=0 ;;
#   2) install_flg=1 ;;
#   *) echo "abort." ;;  
# esac

apt-get update
apt-get upgrade
apt-get install -y nkf git dnsutils
# dnsutils -> for host command

# COMMOM_USER="ftakao2007"
COMMOM_USER=$1

# COMMOM_EMAIL="ftakao2007@gmail.com"
COMMOM_EMAIL=$2

# INIT_PASSWD="hoge"
INIT_PASSWD=$3

### DTI VPS setting
./099_dtivps_init.sh

### server user add
./098_useradd.sh ${COMMOM_USER}

### git setting
./101_git.sh ${COMMOM_USER} ${COMMOM_EMAIL}

if [ ${install_flg} = "1" ]; then
  ### jenkins install
  ./002_jenkins.sh ${COMMOM_USER} ${COMMOM_EMAIL} ${INIT_PASSWD}
fi
