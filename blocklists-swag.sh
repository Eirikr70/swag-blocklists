#!/bin/bash

set -e

cd "$(dirname "$0")"

LOG_FILE="./blocklists-swag.log"

# Initiate log file
date >"$LOG_FILE"

# list of known spammers
URLS="./urls.txt"

TMP_FILE=$(mktemp)

DEST_FILE=$(mktemp)

SORTED_FILE=$(mktemp)

SWAG_BLOCKLIST=$1

# dump blocklists

cat $URLS | while read URL ; do
        echo "Fetching '$URL' ..." | tee -a "$LOG_FILE"
        echo "STEP '$URL'" >>"$TMP_FILE"
        curl -Ss "$URL" | grep -e "" | tee -a "$TMP_FILE" > /dev/null
done

# create aggregated blocklist

for IP in $( cat "$TMP_FILE" | grep -Po '(?:\d{1,3}\.){3}\d{1,3}(?:/\d{1,2})?' | cut -d' ' -f1 ); do

        echo "deny $IP;" >>"$DEST_FILE"

done

# sort addresses

sort -u "$DEST_FILE" >"$SORTED_FILE"

# move list to SWAG blocklist

cp "$SORTED_FILE" "$SWAG_BLOCKLIST"

# close and wipe tmp files

LINES="$(wc -l <$SWAG_BLOCKLIST)"

echo "IP count: '$LINES'" | tee -a "$LOG_FILE"

rm $TMP_FILE $DEST_FILE $SORTED_FILE
