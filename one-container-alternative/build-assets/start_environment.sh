#!/bin/bash

echo "Starting migrate_and_start script..."
./build-assets/migrate_and_start.sh
echo "Finished migrate_and_start script..."

CERT_DIR="/build-assets/certs/tmp"

# Get the filenames of the .crt and .key files
CRT_FILE=$(find $CERT_DIR -name "*.crt" -type f)
KEY_FILE=$(find $CERT_DIR -name "*.key" -type f)

# Check if the files were found
if [ -z "$CRT_FILE" ]; then
    echo "No certificate file found"
    exit 1
fi

if [ -z "$KEY_FILE" ]; then
    echo "No private key file found"
    exit 1
fi

echo "Certificate file: $CRT_FILE"
echo "Private key file: $KEY_FILE"


# mv $CERT_DIR/tmp/*.crt $CERT_DIR/*.crt
# mv $CERT_DIR/tmp/*.key $CERT_DIR/*.key


# Generate the endpoint string for SSL
ENDPOINT="ssl:8480:privateKey=$KEY_FILE:certKey=$CRT_FILE"


echo "Starting daphne..."
daphne -e $ENDPOINT yangsuite.asgi:application
echo "daphne started with exit code $?"