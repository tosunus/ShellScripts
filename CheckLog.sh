#!/usr/bin/env bash

#Usage
# sh CheckLog.sh "TIMES" "searched text" "DIR"
# EXAMPLE
### sh CheckLog.sh "200" "SEARCHME" "/backup/"

TIMES=$1
SEARCH=$2
DIR=$3
listdir=$(ls "$DIR")
tempdir="/root/workout"

for server in $listdir; do
    if [[ -n "$tempdir" ]] && [[ ! -d "${tempdir:?}/${server}" ]]; then
        mkdir -p "${tempdir:?}/${server}";
        find "${DIR}/${server}" -type f \( ! -name "*.der" -and ! -name "*.imza" -and ! -name "*.tsq" \) -mtime -"${TIMES}" -exec cp {} "${tempdir:?}/${server}/" \;
        find "${tempdir:?}/${server}" -type f -exec tar -xvf {} -C "${tempdir:?}/${server}/" \; >/dev/null 2>&1;
        check=$(ls "${tempdir:?}/${server}" | grep "tar.bz")
        if [[ -n "$check" ]] && [[ -d "${tempdir:?}/${server}/tmp/logs/" ]]; then
            check=$(ls "${tempdir:?}/${server}/tmp/logs/" | grep "tar.gz")
            if [[ -n "$check" ]]; then
                find "${tempdir:?}/${server}/tmp/logs/" -type f -name "*.tar.gz" | while read -r dosya; do
                    filename=$dosya;
                    filename=${filename%.*};
                    filename=${filename%.*};
                    dosyaadi=$(echo "$filename" |cut -d/ -f7)
                    tar -xvf "${tempdir:?}/${server}/tmp/logs/${dosyaadi}.tar.gz" --xform='s|^|'"$dosyaadi"'/|S' -C "${tempdir:?}/${server}/tmp/logs/" >/dev/null 2>&1;
                done
                checks=$(find "${tempdir:?}/${server}/tmp/logs/" -type f ! -name "*.tar.gz" | xargs grep -l "$SEARCH"|head -1)
                if [[ -n "$checks" ]]; then
                    echo "$checks";
                    exit 0;
                fi
            fi
        fi
        rm -rf "${tempdir:?}/${server}";
    fi
done
