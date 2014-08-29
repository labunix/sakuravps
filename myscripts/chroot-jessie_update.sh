#!/bin/bash

if [ "`id -u`" -ne "0" ];then
  echo "Sorry, Not Permit User!" >&2
  exit 1
fi

DEBRELEASE=jessie; \

for opt in update upgrade autoremove autoclean;do
  chroot /var/local/${DEBRELEASE} apt-get -y $opt
done

dpkg -l | grep ^rc 
