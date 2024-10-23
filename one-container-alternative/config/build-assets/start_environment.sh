#!/bin/bash

# starts yangsuite, mimics behavior from yangsuite docker-compose 

source /build-assets/setup.env

echo "Starting migrate_and_start.sh..."
/build-assets/migrate_and_start.sh
echo "migrate_and_start.sh started with exit code $?"