#!/bin/sh
set -e

DIR=/sd/backup/cf.kmx.io

SLOT=$(hanoi 4 $(day))
DIR_SLOT=${DIR}/${SLOT}

run() {
    echo "$@"
    "$@"
}

sync() {
        mkdir -p "${DIR_SLOT}$1"
        run rsync -aHPx --delete-before "$1/." "${DIR_SLOT}$1/"
}

echo "$(date "+%F %T") $DIR_SLOT" >> "$DIR/backup.log"

sync /
sync /usr/local
sync /var
