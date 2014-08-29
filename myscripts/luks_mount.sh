#!/bin/bash

if [ `id -u` -ne "0" ] ;then 
  echo "Sorry,Not Permit User!" >&2
  exit 1
fi

USER=labunix
DEST=/home/${USER}/mydata


# if not mount, mount it
test -b /dev/dm-0 || \
  cryptsetup luksOpen /home/luks.img luks --key-file /root/cryptkey

test -d "${DEST}" || \
  mkdir ${DEST}

mount | grep luks >/dev/null || \
  mount /dev/mapper/luks ${DEST}

mount | grep luks



