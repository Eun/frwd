#!/usr/bin/env bash
set -euo pipefail

###################################
# Define your domain here
DOMAIN=example.com
SSHD_PORT=2222

# Define the minimum and maximum random remote ports
MIN_REMOTE_PORT=1024
MAX_REMOTE_PORT=2048
###################################


if [ $# -lt 1 ]; then
    echo "frwd <local-port> [remote-port]"
    echo "   examples:"
    echo "       # spin up a tunnel to port 8000 with a random remote port"
    echo "       frwd 8000"
    echo "       # spin up a tunnel to port 8000 with remote port 1024"
    echo "       frwd 8000 1024"
    exit 1
fi




function isNumberAndInRange() {
    case "$1" in
      ''|*[!0-9]*)
        echo "$1 is not a number"
        exit 1
        ;;
    esac
    if [ "$1" -lt "$2" ]; then
      echo "$1 is not in range (must be greater or equal than $2)"
      exit 1
    fi
    if [ "$1" -gt "$3" ]; then
      echo "$1 is not in range (must be lower or equal than $3)"
      exit 1
    fi
}

# test if local port is a number and in range
isNumberAndInRange "$1" 1 65535
LOCAL_PORT=$1

if [ $# -eq 2 ]; then
  # test if remote port is a number and in range
  isNumberAndInRange "$2" $MIN_REMOTE_PORT $MAX_REMOTE_PORT
  REMOTE_PORT=$2
else
  # randomly generate a random port
  REMOTE_PORT=$(($MIN_REMOTE_PORT + $(($RANDOM % $MAX_REMOTE_PORT))))
fi

echo "tcp://$DOMAIN:$REMOTE_PORT -> 127.0.0.1:$LOCAL_PORT"
echo "http://$REMOTE_PORT.$DOMAIN  -> 127.0.0.1:$LOCAL_PORT"
echo "https://$REMOTE_PORT.$DOMAIN -> 127.0.0.1:$LOCAL_PORT"
ssh -p$SSHD_PORT -T -R $REMOTE_PORT:127.0.0.1:"$LOCAL_PORT" frwd@$DOMAIN
