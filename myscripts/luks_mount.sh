#!/bin/bash

if [ `id -u` -ne "0" ] ;then 
  echo "Sorry,Not Permit User!" >&2
  exit 1
fi

USER=labunix
DEST=/home/${USER}/mydata
LUKS_HEADER_BACKUP=luks.header_`env LANG=C date '+%Y%m%d_%H%M%S'`

cryptsetup luksHeaderBackup /home/luks.img --header-backup-file ${LUKS_HEADER_BACKUP}

test -f ${LUKS_HEADER_BACKUP} && \
  openssl enc -e -aes-256-ofb -in "${LUKS_HEADER_BACKUP}" -out /home/${USER}/mydata/luks.header.enc
rm -f "${LUKS_HEADER_BACKUP}"

chown -R ${USER}:${USER} /home/${USER}/myscripts
test -b /dev/dm-0 || cryptsetup luksOpen /home/luks.img luks
test -d "${DEST}" || mkdir ${DEST}
mount | grep luks >/dev/null || mount /dev/mapper/luks ${DEST}

mount | grep luks



