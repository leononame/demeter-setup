#!/bin/bash

useradd leo
mkdir /home/leo/.ssh
cp /root/.ssh/authorized_keys /home/leo/.ssh/authorized_keys
chown leo:leo /home/leo/.ssh/authorized_keys

