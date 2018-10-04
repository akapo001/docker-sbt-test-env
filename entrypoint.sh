#!/bin/bash

/usr/local/bin/dockerd-entrypoint.sh > /dev/null 2>&1 &

exec "$@"
