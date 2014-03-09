#!/bin/sh

### OS flug
os_flug=`awk '{print $1}' /etc/issue | head -1`

### With soft
cat << __EOT__
input number
0) init only
1) with jenkins
__EOT__
read install_flg

#### case num in
#   1) install_flg=0 ;;
#   2) install_flg=1 ;;
#   *) echo "abort." ;;  
# esac

if [ "${os_flug}" = "CentOS" ]; then
  yum update
  yum install -y nkf git bind-utils
  # bind-utils -> for host command
else
  apt-get update
  apt-get upgrade
  apt-get install -y nkf git dnsutils
  # dnsutils -> for host command
fi

# COMMOM_USER="ftakao2007"
COMMOM_USER=$1

# COMMOM_EMAIL="ftakao2007@gmail.com"
COMMOM_EMAIL=$2

# INIT_PASSWD="hoge"
INIT_PASSWD=$3

### DTIVPS ubuntu12.04 or vagrant centos6.5 setting
./099_dtivps_ubuntu12.04_vagrant_centos6.5_init.sh

### server user add
./098_useradd.sh ${COMMOM_USER}

### git setting
./101_git.sh ${COMMOM_USER} ${COMMOM_EMAIL}


if [ ${install_flg} = "1" ]; then
  ### jenkins install
  ./002_jenkins.sh ${COMMOM_USER} ${COMMOM_EMAIL} ${INIT_PASSWD}
fi
