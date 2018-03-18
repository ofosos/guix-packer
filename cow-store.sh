#!/bin/bash

TARGET=/mnt
BACKING_DIR=/tmp/guix-inst
STORE_PREFIX=/gnu/store

tmpdir=$TARGET/tmp
mkdir -p tmpdir
mount --bind /tmp $tmpdir
rwdir=$TARGET/$BACKING_DIR
workdir=$rwdir/../.overlayfs-workdir

mkdir -p $rwdir
mkdir -p $workdir
mkdir -p /.rw-store

chown 30000 $rwdir
chmod 1775 $rwdir
chown 30000 /.rw-store
chmod 1775 /.rw-store

mount --make-private /

mount -t overlay overlay -o lowerdir=$STORE_PREFIX,upperdir=$rwdir,workdir=$workdir /.rw-store
mount --move /.rw-store $STORE_PREFIX
rmdir /.rw-store

