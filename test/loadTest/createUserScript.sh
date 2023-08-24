#!/bin/bash

HOST="http://193.196.39.104:3000"
CONTENT_TYPE="application/json"
PASSWORD="12345678"

SLEEP_INTERVAL_MIN=0.5
SLEEP_INTERVAL_MAX=2.5

# Generiere einen zufälligen Schlafwert
RANDOM_SLEEP=$(echo "$SLEEP_INTERVAL_MIN + ($RANDOM * ($SLEEP_INTERVAL_MAX - $SLEEP_INTERVAL_MIN) / 32767)" | bc -l)

# Verwende den zufälligen Wert

for i in {999..1100}
do
    USERNAME="user${i}"
    EMAIL="user${i}@loadtest.org"

    # JSON-Daten für den POST-Request erstellen
    DATA="{\"userName\":\"${USERNAME}\",\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\"}"

    # curl POST request ausführen
    curl -X POST \
        -H "Content-Type: ${CONTENT_TYPE}" \
        -d "${DATA}" \
        "${HOST}/auth/register"
        
    # Kurze Pause zwischen den Anfragen
    sleep $RANDOM_SLEEP
done
