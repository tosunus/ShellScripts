#!/usr/bin/env bash

CP_ACCOUNTS=$(ls -1A /var/cpanel/users/)

for user in $(echo -n "$CP_ACCOUNTS"); do
    dirnames="/home/${user}/public_html"
    if [[ -d $dirnames ]]; then
        rsync -avz -e "ssh -p PORT" root@IPADDRESS:"${dirnames}"/* "${dirnames}"/;
    fi
done
