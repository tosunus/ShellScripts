#!/usr/bin/env bash

username=$1
tarih=$2
dizin=$3

find "$dizin" -type f -name "*${tarih}.tar.bz" | while read -r dosya; do
    filename=$dosya;
    filename=${filename%.*};
    filename=${filename%.*};
    dosyaadi=$(echo "$filename" |cut -d/ -f5)
    dosyaadi="${username}-${dosyaadi}"
    tar -xvf "$dosya" tmp/logs/"${dosyaadi}".tar.gz;
    tar -xvf tmp/logs/"${dosyaadi}".tar.gz --xform='s|^|'"$dosyaadi"'/|S' -C "${dizin}/yedek";
    echo "${dizin}/yedek/${dosyaadi}";
done
