#!/bin/sh

ceph osd pool create cephfs_data 256
sleep 100
ceph osd pool create cephfs_metadata 256
sleep 30
ceph fs new cephfs cephfs_metadata cephfs_data
ceph fs ls
ceph -s

