#!/bin/bash

/usr/local/bin/dockerd-entrypoint.sh &

exec $@