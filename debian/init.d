#!/bin/sh
### BEGIN INIT INFO
# Provides:          nfsen
# Required-Start:    $network $local_fs $remote_fs
# Required-Stop:     $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: nfsen
# Description:       nfdump tools
#                    <...>
#                    <...>
### END INIT INFO

# Author: John Francesco Ferlito <johnf@inodes.org>

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC=nfsen             # Introduce a short description here
NAME=nfsen             # Introduce the short server's name here
DAEMON=/usr/bin/nfsen  # Introduce the server's location here
DAEMON_ARGS=""             # Arguments to run the daemon with
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
USER=www-data
GROUP=www-data

# Exit if the package is not installed
[ -x $DAEMON ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
. /lib/lsb/init-functions

case "$1" in
  start)
    [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC " "$NAME"
    mkdir -p /var/run/nfsen
    sudo chown -R $USER.$GROUP-data /var/run/nfsen
    $DAEMON start
    case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
  ;;
  stop)
	[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
	$DAEMON stop
	case "$?" in
		0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
		2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	esac
	;;
  status)
       status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
       ;;
  restart|force-reload)
	#
	# If the "reload" option is implemented then remove the
	# 'force-reload' alias
	#
	log_daemon_msg "Restarting $DESC" "$NAME"
	$DAEMON stop
	case "$?" in
	  0|1)
		$DAEMON start
		case "$?" in
			0) log_end_msg 0 ;;
			1) log_end_msg 1 ;; # Old process is still running
			*) log_end_msg 1 ;; # Failed to start
		esac
		;;
	  *)
	  	# Failed to stop
		log_end_msg 1
		;;
	esac
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|status|restart}" >&2
	exit 3
	;;
esac

:
