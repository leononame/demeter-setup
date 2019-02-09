#!/bin/bash

mkdir -p "${DATA_DIR}/nginx/conf.d"
if [ ! -f "${DATA_DIR}/nginx/conf.d/wordpress.conf" ]; then
    j2 -f env wordpress.conf > "${DATA_DIR}/nginx/conf.d/wordpress.conf"
fi
