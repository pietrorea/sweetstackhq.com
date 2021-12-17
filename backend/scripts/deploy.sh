#!/bin/bash

# Pulls from from github, builds and starts with forever.
# Usage: typically called with `npm run deploy`.

set -e 

FOREVER_NAME=marketing-service

echo "Pulling from GitHub"
git pull

echo "Pulling any new deps"
npm i

echo "Cleaning and building"
npm run build

echo "Stopping forever process"
forever stop "${FOREVER_NAME}" || true

echo "Starting with forever"
forever start --minUptime 1000 --spinSleepTime 1000 --uid "${FOREVER_NAME}" -a out-tsc/src/index.js
