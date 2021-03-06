#!/bin/bash

# self-destruct script for DigitalOcean droplet
# ==============================================================================

if [[ $# -ne 3 ]]; then
    echo "usage: ./self-destruct.sh <API-Token> <Droplet-Id> <Minutes>"
    exit 1
fi

API_TOKEN=$1
DROPLET_ID=$2
SLEEP_MINUTES=$3

echo "called ./self-destruct.sh <API_TOKEN> ${DROPLET_ID} ${SLEEP_MINUTES}"

function destroyVM {
	echo "curl -X DELETE -i -H \"Authorization: Bearer <API_TOKEN>\" \"https://api.digitalocean.com/v2/droplets/${DROPLET_ID}\""
	curl -X DELETE -i -H "Authorization: Bearer ${API_TOKEN}" "https://api.digitalocean.com/v2/droplets/${DROPLET_ID}"
	exit $?
}

SLEEP_SECONDS=$(( SLEEP_MINUTES * 60 ))
DEADLINE=$(( `date +%s` + SLEEP_SECONDS ))
while true; do
	CURRENTTIME=`date +%s`
	if [[ $CURRENTTIME -gt $DEADLINE ]]; then
		destroyVM
	fi

	sleep 5
done

exit 0
