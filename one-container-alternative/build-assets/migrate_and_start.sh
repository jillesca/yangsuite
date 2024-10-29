#!/bin/bash
# Start the yanguite service in production.

# Get the system yangsuite location
PY=python3
YS_DIR=$(pip show yangsuite | grep "^Location"|cut -d" " -f 2)/yangsuite

cd $YS_DIR && \
  ${PY} manage.py collectstatic --noinput && \
  ${PY} manage.py makemigrations && \
  ${PY} manage.py migrate

if [ -z "${YS_ADMIN_USER}" ]
then
    echo "No ADMIN USER set"
fi
if [ -z "${YS_ADMIN_PASS}" ]
then
    echo "No ADMIN PASSWORD set"
fi
if [ -z "${YS_ADMIN_EMAIL}" ]
then
    echo "No ADMIN EMAIL set"
fi

echo "from django.contrib.auth.models import User; User.objects.create_superuser('${YS_ADMIN_USER}', '${YS_ADMIN_EMAIL}', '${YS_ADMIN_PASS}')" | ${PY} ${YS_DIR}/manage.py shell

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
# --ssl-certfile $CRT_FILE --ssl-keyfile $KEY_FILE

# Generate the endpoint string for SSL
ENDPOINT="ssl:8480:privateKey=$KEY_FILE:certKey=$CRT_FILE"


echo "Starting daphne..."
daphne -e $ENDPOINT yangsuite.asgi:application
echo "daphne started with exit code $?"