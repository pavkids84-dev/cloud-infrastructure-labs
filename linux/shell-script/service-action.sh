#!/bin/bash

# Demonstrates command selection using a case statement.

if (( $# != 1 ))
then
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
fi

case "$1" in
    start)
        echo "Selected action: start"
        ;;
    stop)
        echo "Selected action: stop"
        ;;
    restart)
        echo "Selected action: restart"
        ;;
    status)
        echo "Selected action: status"
        ;;
    *)
        echo "Error: Unknown action '$1'"
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
