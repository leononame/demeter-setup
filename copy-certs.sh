#!/bin/bash

# All dirs in /etc/letsencrypt/live (usually domains)
for dir in /etc/letsencrypt/live/*/; do
    # All pem files (i.e., the symlinks to the certs)
    for f in $dir*.pem; do
        # If file is symlink
        if test -h $f; then
            # Read canonical link target and replace link by target
            target=`readlink -f $f`
            rm -f $f
            cp $target $f
        fi
    done
    cd ..
done
