#! /bin/sh
### BEGIN INIT INFO
# Provides:          cryptmount
# Required-Start:    cryptdisks
# Required-Stop:     umountfs,cryptdisks
# Should-Start:      2
# Default-Start:     2
# Default-Stop:      5,6
# Short-Description: automount /home/luks.img
# Description:       local use.
### END INIT INFO

PATH=/sbin:/usr/sbin:/bin:/usr/bin

. /lib/lsb/init-functions

case "$1" in
  start)
	CRYPTSTART=/home/labunix/myscripts/luks_mount.sh
        test -x $CRYPTSTART && /bin/bash $CRYPTSTART
	;;
  restart|reload|force-reload)
	echo "Error: argument '$1' not supported" >&2
	exit 3
	;;
  stop)
	CRYPTSTOP=/home/labunix/myscripts/luks_unmount.sh
        test -x $CRYPTSTOP && /bin/bash $CRYPTSTOP
	;;
  status)
        cryptsetup status luks
	exit $?
	;;
  *)
	echo "Usage: cryptmount [start|stop|status]" >&2
	exit 3
	;;
esac

:
