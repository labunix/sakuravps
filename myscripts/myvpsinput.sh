#!/bin/bash 

if [ `id -u` -ne "0" ];then
  echo "Sorry Not Permit User!" >&2
  exit 1
fi

export PATH=/sbin:/usr/sbin:/bin:/usr/bin

IPTABLES=/sbin/iptables
FAIL2BAN=/etc/init.d/fail2ban
SSHDCONFIG=/var/local/jessie/etc/ssh/sshd_config
NTPDCONFIG=/etc/ntp.conf
SMTPPORT=587

# at 1st

if [ -x $FAIL2BAN ];then
  $FAIL2BAN stop
else
  FAIL2BAN="x"
fi

$IPTABLES -P INPUT ACCEPT
$IPTABLES -F -t filter
$IPTABLES -F -t nat

$IPTABLES -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A INPUT -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
$IPTABLES -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$IPTABLES -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# for ssh
if [ -f $SSHDCONFIG ];then
  grep ^Port $SSHDCONFIG | awk '{print $2}' | \
  for SSHPORT in `xargs`;do
    $IPTABLES -A INPUT -p tcp -m tcp --dport $SSHPORT -j ACCEPT
  done
else
  SSHPORT=22
  $IPTABLES -A INPUT -p tcp -m tcp --dport $SSHPORT -j ACCEPT
fi

# for web services
$IPTABLES -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# for mail services
$IPTABLES -A INPUT -p tcp -m tcp --dport $SMTPPORT -j ACCEPT

# for xrdp services

# for ntp

#grep ^server $NTPDCONFIG  | awk '{print $2}' | \
#  for list in `xargs`;do
#    $IPTABLES -A INPUT -p udp -m udp -s ${list} --dport 123 -j ACCEPT
#  done

# for lo

$IPTABLES -A INPUT -i lo -j ACCEPT

# eth0

FLAG=`ip a list eth0 | grep "state UP" > /dev/null 2>&1;echo $?`

if [ "$FLAG" -eq "0" ];then
  MYIP=$(ip a list eth0 | grep "inet " | awk '{print $2}' | sed s%/[0-9]*%%)
  $IPTABLES -A INPUT -p udp -m udp -d $MYIP -j ACCEPT

  $IPTABLES -A INPUT -d 224.0.0.1 -j DROP
fi

if [ -x $FAIL2BAN ];then
  $FAIL2BAN start
fi

# default policy
$IPTABLES -P INPUT DROP

if [ -x $FAIL2BAN ];then
  # for save
  $FAIL2BAN restart
fi

$IPTABLES -L -v -n 
unset IPTABLES MYIP FLAG FAIL2BAN SSHDCONFIG NTPDCONFIG SSHPORT SMTPPORT PATH
exit 0

