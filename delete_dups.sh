#!/usr/bin/env bash

declare -A hashes

find $1 -type f | while read filename
do
    hash=`sha256sum "$filename" | cut -f 1 -d " "`
    if [[ -n "${hashes[$hash]}" ]] 
    then
        echo deleting duplicate file $filename
        rm "$filename"
    else
        hashes[$hash]="1"
    fi
done
