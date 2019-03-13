#!/bin/bash

bdir=/etc/mailucerts
mkdir -f $bdir

# All dirs in /etc/letsencrypt/live (usually domains)
for dir in /etc/letsencrypt/live/*/; do
    # All pem files (i.e., the symlinks to the certs)
    for f in $dir*.pem; do
        domain=$(basename $dir)
        mkdir -p $bdir/$domain
        # If file is symlink
        if test -h $f; then
            # Read canonical link target
            origin=$(readlink -f $f)
            target=$bdir/$domain/$(basename $f)
            cp $origin $target
        fi
    done
done
