#!/bin/bash

# Restarts with forever.
# Usage: typically called with `npm run restart`.

set -e 

echo "Stopping forever process"
forever stopall

echo "Starting with forever"
forever start --minUptime 1000 --spinSleepTime 1000 out-tsc/src/index.js


