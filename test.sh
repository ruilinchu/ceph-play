#!/bin/sh

# correct the pg and pgp num first ceph always set 64
ceph osd pool set rbd pg_num `grep pg_num edit_ceph-ansible-master.sh | awk '{print $2}'`
sleep 60
ceph osd pool set rbd pgp_num `grep pgp_num edit_ceph-ansible-master.sh | awk '{print $2}'`
sleep 30

ceph osd pool create cephfs_data `grep pg_num edit_ceph-ansible-master.sh | awk '{print $2}'`
ceph osd pool create cephfs_metadata `grep pg_num edit_ceph-ansible-master.sh | awk '{print $2}'`
ceph fs new cephfs cephfs_metadata cephfs_data
sleep 30
ceph fs ls
ceph -s

#pdsh -w chunk[1-3] < test

