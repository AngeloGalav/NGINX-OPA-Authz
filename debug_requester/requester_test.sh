#!/bin/bash

echo "Starting requester..."
role="";
operation=""

if [ -z "$1" ]; then
    echo "you must input a role for this to work (or enable the JWT)"
    exit 1
else 
    role="$1"
fi

if [ "$2" == "-t" ] || [ -z "$2" ]; then
    echo "you must input an operation for this to work"
    exit 1
else
    operation="$2"
fi

if [ "$operation" = "image_request" ]; then 
    curl --cacert "./nginx_docker_revproxy/certificates_for_https/igi-test-ca.pem" "https://servicecnaf.test.example:8081/operation/image_request" -H "X-Role: $role" -H "X-Operation: image_request" -H "X-EnableJWT: false" --output test.jpg
else
    curl -Li --cacert "./nginx_docker_revproxy/certificates_for_https/igi-test-ca.pem" -X "POST" "https://servicecnaf.test.example:8081/operation/" -H "X-Role: $role" -H "X-Operation: $operation" -H "X-EnableJWT: false" 
fi
