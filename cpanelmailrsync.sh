#!/usr/bin/env bash

CP_ACCOUNTS=$(ls -1A /var/cpanel/users/)

for user in $(echo -n "$CP_ACCOUNTS"); do
    domains=$(grep -i ^dns /var/cpanel/users/"${user}" |cut -d= -f2)
    echo "$domains" | while read -r domain; do
        dirnames="/home/${user}/mail/${domain}"
        if [[ ! -d $dirnames ]]; then
            echo "$dirnames";
        fi
    done
done
