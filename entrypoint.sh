#!/bin/bash

/usr/local/bin/dockerd-entrypoint.sh > /dev/null 2>&1 &

# Wait until started docker
if timeout 30 bash -c 'until docker info > /dev/null 2>&1; do sleep 1; done'
then
    exec "$@"
else
    echo '[ERROR] Failed to launch docker. Is the --privileged option enabled?' >&2
fi
