#!/bin/bash

# Restarts with forever.
# Usage: typically called with `npm run restart`.

set -e 

FOREVER_NAME=marketing-service

echo "Stopping forever process"
forever stop "${FOREVER_NAME}" || true

echo "Restarting with forever"
forever start --minUptime 1000 --spinSleepTime 1000 --uid "${FOREVER_NAME}" out-tsc/src/index.js
