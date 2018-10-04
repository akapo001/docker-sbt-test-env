#!/bin/bash

/usr/local/bin/dockerd-entrypoint.sh &

echo "exec \"$@\""

exec "$@"
