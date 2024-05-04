#!/bin/bash
set -e

bundle install -j3

ruby -v

node -v

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
