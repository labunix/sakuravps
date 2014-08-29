#!/bin/bash

if [ `id -u` -ne "0" ] ;then 
  echo "Sorry,Not Permit User!" >&2
  exit 1
fi

USER=labunix
DEST=/home/${USER}/mydata
umount $DEST
cryptsetup luksClose luks

# header backup

LUKS_HEADER_BACKUP=luks.header
test -f ${DEST}/${LUKS_HEADER_BACKUP} && rm -f ${DEST}/${LUKS_HEADER_BACKUP}

test -f /home/luks.img && \
  cryptsetup luksHeaderBackup /home/luks.img --header-backup-file ${DEST}/${LUKS_HEADER_BACKUP}

mount | grep luks





