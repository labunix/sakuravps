#!/bin/bash

if [ `id -u` -ne "0" ] ;then 
  echo "Sorry,Not Permit User!" >&2
  exit 1
fi

USER=labunix
DEST=/home/${USER}/mydata
umount $DEST
cryptsetup luksClose luks

mount | grep luks





