#!/bin/bash

/usr/local/bin/dockerd-entrypoint.sh > /dev/null &

exec "$@"
