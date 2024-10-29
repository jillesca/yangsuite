#!/bin/bash

echo "Starting migrate_and_start script..."
./build-assets/migrate_and_start.sh
echo "Finished migrate_and_start script..."

USER_CERT_DIR="/certificate"
SELF_SIGNED_CERT_DIR="/build-assets/self_signed_certificates/"

# Get the filenames of the user-provided .crt and .key files
USER_CRT_FILE=$(find $USER_CERT_DIR -name "*.crt" -type f)
USER_KEY_FILE=$(find $USER_CERT_DIR -name "*.key" -type f)

# Get the filenames of the self-signed .crt and .key files
SELF_SIGNED_CRT_FILE=$(find $SELF_SIGNED_CERT_DIR -name "*.crt" -type f)
SELF_SIGNED_KEY_FILE=$(find $SELF_SIGNED_CERT_DIR -name "*.key" -type f)

# Function to check if a certificate and key are valid
check_certificate() {
    local crt_file=$1
    local key_file=$2

    # Check if the certificate and key match
    openssl x509 -noout -modulus -in "$crt_file" | openssl md5
    openssl rsa -noout -modulus -in "$key_file" | openssl md5

    if [ $? -ne 0 ]; then
        echo "Certificate and key do not match or are corrupted."
        return 1
    fi

    # Check if the certificate is expired
    openssl x509 -checkend 0 -noout -in "$crt_file"
    if [ $? -ne 0 ]; then
        echo "Certificate is expired."
        return 1
    fi

    echo "Certificate and key are valid."
    return 0
}


# Check if user-provided files were found
if [ -n "$USER_CRT_FILE" ] && [ -n "$USER_KEY_FILE" ]; then
    CRT_FILE=$USER_CRT_FILE
    KEY_FILE=$USER_KEY_FILE
    echo "Using user-provided certificate and key files."
else
    CRT_FILE=$SELF_SIGNED_CRT_FILE
    KEY_FILE=$SELF_SIGNED_KEY_FILE
    echo "User-provided certificate or key file not found."
    echo "Using self-signed certificates."
fi

# Check if the final certificate and key files were found
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

# Validate the certificate and key
check_certificate "$CRT_FILE" "$KEY_FILE"
if [ $? -ne 0 ]; then
    echo "Invalid certificate or key."
    exit 1
fi

# Here you can add the logic to pass these files to Daphne or any other service
# For example:

# Generate the endpoint string for SSL
ENDPOINT="ssl:8480:privateKey=$KEY_FILE:certKey=$CRT_FILE"


echo "Starting daphne..."
daphne --endpoint $ENDPOINT yangsuite.asgi:application
echo "daphne started with exit code $?"