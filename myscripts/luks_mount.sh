#!/bin/bash

if [ `id -u` -ne "0" ] ;then 
  echo "Sorry,Not Permit User!" >&2
  exit 1
fi

USER=labunix
DEST=/home/${USER}/mydata
test -b /dev/dm-0 || cryptsetup luksOpen /home/luks.img luks
test -d "${DEST}" || mkdir ${DEST}
mount | grep luks >/dev/null || mount /dev/mapper/luks ${DEST}

mount | grep luks



