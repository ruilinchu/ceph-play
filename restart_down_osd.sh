#!/bin/bash

for down_osd in $(ceph osd tree | awk '/down/ {print $1}')
do
    host=$(ceph osd find $down_osd | awk -F\" '$2 ~ /host/ {print $4}')
    ssh $host systemctl restart ceph-osd@$down_osd
done
