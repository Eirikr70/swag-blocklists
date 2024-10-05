#!/bin/bash

set -e

# Initiate log file
date >/home/eric/swag/blocklists/blocklists-swag.log

# list of known spammers
URLS="/home/eric/swag/blocklists/urls.txt"

TMP_FILE="/home/eric/swag/blocklists/tmp.txt"

DEST_FILE="/home/eric/swag/blocklists/blocklists.txt"

SORTED_FILE="/home/eric/swag/blocklists/blocklists_sorted.txt"

SWAG_BLOCKLIST="/home/eric/swag/config/nginx/blockips.conf"

# initialise temp file
echo "" >"$TMP_FILE"

cat $URLS | while read URL ; do
	echo "Fetching '$URL' ..."
 	curl -Ss "$URL" | grep -e "" | tee -a "$TMP_FILE" > /dev/null
done

# create blocklist
# empty blocklist

echo "" >"$DEST_FILE"

# iterate through all known spamming hosts
# for SUBNET in $( cat "$TMP_FILE" | grep -e "^\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\/[0-9]\{1,2\} " | cut -d' ' -f1 ); do

# 	echo $SUBNET >>"$DEST_FILE"

# done

for IP in $( cat "$TMP_FILE" | grep -Po '(?:\d{1,3}\.){3}\d{1,3}(?:/\d{1,2})?' | cut -d' ' -f1 ); do

	echo "deny $IP;" >>"$DEST_FILE"

done

# sort addresses

sort -u "$DEST_FILE" >"$SORTED_FILE"

# move list to SWAG blocklist

cp "$SORTED_FILE" "$SWAG_BLOCKLIST"
