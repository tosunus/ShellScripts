#!/usr/bin/env bash

CP_ACCOUNTS=$(ls -1A /var/cpanel/users/)

for user in $(echo -n "$CP_ACCOUNTS"); do
    domain=$(grep -i ^dns /var/cpanel/users/"${user}" |cut -d= -f2)
    for dom in $(echo -n "$domain"); do
        dirname="/home/${user}/mail/${dom}"
        if [[ -d $dirname ]]; then
            rsync -avz -e "ssh -p PORT" root@IPADDRESS:"${dirname}"/* "${dirname}"/;
            /scripts/remove_dovecot_index_files --user "$user";
        fi
    done
done
