# swag-blocklists
Blocklists aggregator for linuxserver/docker-swag

This little script is designed to aggregate multiple public blocklists and feed a blacklist for linuxserver/docker-swag.
This utility is made available as is. It is not guaranteed and is not supported by the linuxserver.io team. Feel free to hack it to improve it, in particular to make it more secure. All suggestions for improvement are welcome.

It is based in particular on previous work by wallyhall : https://github.com/wallyhall/spamhaus-drop

Read it before you import it.

Before using it, you should control the paths of the different files.

This script is quite basic, so any improving proposal will be welcome. It can also be used with any other reverse-proxy, taking care of the destination path.

You can also change the list of the public blocklists you want aggregated in url.txt.

# Usage

Install the `blocklists-swag.sh` file and, when in the current directory, execute

```
(sudo) ./blocklist-swag.sh /path/of/the/swag/or/nginx/blockips.conf
```

You can install a cron job to periodically run it.
