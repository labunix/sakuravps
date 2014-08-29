#!/bin/bash

if [ `id -u` -ne "0" ];then
  echo "Sorry, Not Permit User!" >&2
  exit 1
fi

USER=labunix
HOME_DIR=/home/${USER}
CHROOT_DIR=/var/local/jessie${HOME_DIR}

for TARGET in myscripts mydata;do
  FLAG=`mount | grep ${CHROOT_DIR}/${TARGET} | wc -l`
  if [ "$FLAG" -eq "0" ];then
    echo "mount..."
    test -d ${CHROOT_DIR}/${TARGET} || mkdir -p ${CHROOT_DIR}/${TARGET}
    test -d ${CHROOT_DIR}/${TARGET} && chown -R ${USER}:${USER} ${CHROOT_DIR}/${TARGET}
    test -d ${HOME_DIR}/${TARGET} && chown -R ${USER}:${USER} ${HOME_DIR}/${TARGET}
    if [ -d ${CHROOT_DIR}/${TARGET} -a -d ${HOME_DIR}/${TARGET} ] ;then
      mount --bind ${HOME_DIR}/${TARGET} ${CHROOT_DIR}/${TARGET}
      mount | grep ${TARGET} | awk '{print $3}'
    fi
  fi
done

while [ "$YN" != "Y" ]; do
  echo -n "unmount chroot ok? [Y/n]"
  read YN
  for TARGET in myscripts mydata;do
  FLAG=`mount | grep ${CHROOT_DIR}/${TARGET} | wc -l`
  if [ "$FLAG" -ne "0" ];then
    echo "unmount..."
    umount ${CHROOT_DIR}/${TARGET}
    mount | grep ${TARGET} | awk '{print $3}'
  fi
  done
done

