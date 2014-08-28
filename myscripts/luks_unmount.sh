#!/bin/bash

if [ `id -u` -ne "0" ] ;then 
  echo "Sorry,Not Permit User!" >&2
  exit 1
fi

LUKS_HEADER_BACKUP=luks.header_`env LANG=C date '+%Y%m%d_%H%M%S'`

USER=labunix
DEST=/home/${USER}/mydata
umount $DEST
cryptsetup luksClose luks
cryptsetup luksHeaderBackup /home/luks.img --header-backup-file ${LUKS_HEADER_BACKUP}
test -f ${LUKS_HEADER_BACKUP} && \
  openssl enc -e -aes-256-ofb -in "${LUKS_HEADER_BACKUP}" -out /home/${USER}/myscripts/${LUKS_HEADER_BACKUP}.enc && \
  rm -f "${LUKS_HEADER_BACKUP}"
chown -R ${USER}:${USER} /home/${USER}/myscripts

mount | grep luks





