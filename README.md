# ceph-play

```
vagrant up
vagrant ssh chunk1
cd /vagrant
sudo su
./deploy.sh
./test.sh

[root@chunk1 vagrant]# ceph -s
  cluster a27d76e2-479c-4305-9f34-3bd7e2699fff
     health HEALTH_OK
     monmap e1: 3 mons at {chunk1=10.0.15.11:6789/0,chunk2=10.0.15.12:6789/0,chunk3=10.0.15.13:6789/0}
            election epoch 4, quorum 0,1,2 chunk1,chunk2,chunk3
     mdsmap e15: 1/1/1 up {0=chunk3=up:active}
     osdmap e32: 9 osds: 9 up, 9 in
      pgmap v117: 768 pgs, 3 pools, 600 MB data, 170 objects
            1518 MB used, 78950 MB / 80468 MB avail
                 768 active+clean

[root@chunk1 vagrant]# pdsh -w chunk[1-3] < test

pdsh> mkdir -p /mnt/kernel_cephfs
pdsh> mount -t ceph 10.0.15.11:6789:/ /mnt/kernel_cephfs -o name=admin,secret=`ceph-authtool -p /etc/ceph/ceph.client.admin.keyring`
pdsh> dd if=/dev/zero of=/mnt/kernel_cephfs/$HOSTNAME-file count=200 bs=1M
chunk1: 200+0 records in
chunk1: 200+0 records out
chunk1: 209715200 bytes (210 MB) copied, 3.04563 s, 68.9 MB/s
chunk2: 200+0 records in
chunk2: 200+0 records out
chunk2: 209715200 bytes (210 MB) copied, 3.55516 s, 59.0 MB/s
chunk3: 200+0 records in
chunk3: 200+0 records out
chunk3: 209715200 bytes (210 MB) copied, 5.351 s, 39.2 MB/s
pdsh>


```   