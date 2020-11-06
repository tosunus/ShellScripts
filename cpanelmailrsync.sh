#!/usr/bin/env bash

CP_ACCOUNTS=$(ls -1A /var/cpanel/users/)

for user in $(echo -n "$CP_ACCOUNTS"); do
    domains=$(grep -i ^dns /var/cpanel/users/"${user}" |cut -d= -f2)
    echo "$domains" | while read -r domain; do
        dirnames="/home/${user}/mail/${domain}"
        echo "$dirnames" |while read -r dirname; do
            if [[ ! -d $dirname ]]; then
                echo "$dirname";
            fi
        done
    done
done
