#!/bin/bash

# Pulls from from github, builds and starts with forever.
# Usage: typically called with `npm run deploy`.

set -e 

echo "Pulling from GitHub"
git pull

echo "Pulling any new deps"
npm i

echo "Cleaning and building"
npm run build

echo "Stopping forever process"
forever stop out-tsc/src/index.js

echo "Starting with forever"
forever start --minUptime 1000 --spinSleepTime 1000 out-tsc/src/index.js


