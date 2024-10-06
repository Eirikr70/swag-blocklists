#!/bin/bash

set -e

LOG_FILE="/var/log/blocklists/blocklists-swag.log"

# Initiate log file
date >"$LOG_FILE"

# list of known spammers
URLS="~/urls.txt"

TMP_FILE="/tmp/tmp.txt"

DEST_FILE="/tmp/blocklists.txt"

SORTED_FILE="/tmp/blocklists_sorted.txt"

SWAG_BLOCKLIST=$1

# initialise temp file
>"$TMP_FILE"

cat $URLS | while read URL ; do
	echo "Fetching '$URL' ..." | tee -a "$LOG_FILE"
 	curl -Ss "$URL" | grep -e "" | tee -a "$TMP_FILE" > /dev/null
done

# create blocklist
# empty blocklist

>"$DEST_FILE"

for IP in $( cat "$TMP_FILE" | grep -Po '(?:\d{1,3}\.){3}\d{1,3}(?:/\d{1,2})?' | cut -d' ' -f1 ); do

	echo "deny $IP;" >>"$DEST_FILE"

done

# sort addresses

sort -u "$DEST_FILE" >"$SORTED_FILE"

# move list to SWAG blocklist

cp "$SORTED_FILE" "$SWAG_BLOCKLIST"

LINES="$(wc -l <$SWAG_BLOCKLIST)"

echo "IP count: '$LINES'" | tee -a "$LOG_FILE"
