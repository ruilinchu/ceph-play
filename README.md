```
$vagrant up
$vagrant ssh 
$cd /vagrant
$sudo su
#./deploy.sh

## if error out try once more
#cd ceph-ansible-master
## !! not in the directory can cause ansible module errors
#ansible-playbook site.yml

## cephfs write test
#./test.sh

[root@ceph-osd1 ceph-play]# ceph -w
    cluster c5f1483a-4cf6-4d7f-9c64-d1de2a245686
    health HEALTH_OK
    monmap e1: 3 mons at {ceph-osd1=10.0.15.21:6789/0,ceph-osd2=10.0.15.22:6789/0,ceph-osd3=10.0.15.23:6789/0}
           election epoch 42, quorum 0,1,2 ceph-osd1,ceph-osd2,ceph-osd3
    mdsmap e25: 1/1/1 up {0=ceph-osd1=up:active}, 1 up:standby
    osdmap e152: 12 osds: 12 up, 12 in
           flags sortbitwise
    pgmap v16751: 768 pgs, 3 pools, 19362 MB data, 8016 objects
          58674 MB used, 48617 MB / 104 GB avail
                768 active+clean

2016-02-19 00:45:50.387653 mon.0 [INF] pgmap v16751: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail
2016-02-19 00:55:44.631846 mon.0 [INF] pgmap v16752: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 7059 B/s rd, 0 op/s
2016-02-19 00:55:45.755423 mon.0 [INF] pgmap v16753: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 110 kB/s rd, 3 B/s wr, 0 op/s
2016-02-19 00:55:46.817228 mon.0 [INF] pgmap v16754: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 54558 kB/s rd, 924 B/s wr, 27 op/s
2016-02-19 00:55:47.896390 mon.0 [INF] pgmap v16755: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 38227 kB/s rd, 18 op/s
2016-02-19 00:55:48.927312 mon.0 [INF] pgmap v16756: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 24889 kB/s rd, 12 op/s
2016-02-19 00:55:50.081512 mon.0 [INF] pgmap v16757: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 37769 kB/s rd, 18 op/s
2016-02-19 00:55:51.103730 mon.0 [INF] pgmap v16758: 768 pgs: 768 active+clean; 19362 MB data, 58674 MB used, 48617 MB / 104 GB avail; 116 MB/s rd, 58 op/s

[root@ceph-osd1 ceph-play]# ls /var/run/ceph/
ceph-mds.ceph-osd1.asok  ceph-mon.ceph-osd1.asok  ceph-osd.2.asok  ceph-osd.5.asok  ceph-osd.7.asok  rbd-clients

[root@ceph-osd1 ceph-play]# ceph daemonperf mon.ceph-osd1
--paxos-- -----mon------
cmt  clat|sess sadd srm |
  0    0 |  8    0    0
  0    0 |  8    0    0
    
[root@ceph-osd1 ceph-play]# ceph daemonperf mds.ceph-osd1
-----mds------ --mds_server-- ---objecter--- -----mds_cache----- ---mds_log----
rlat inos caps|hsr  hcs  hcr |writ read actv|recd recy stry purg|segs evts subm|
  0  7.1k 1.5k|  0    0    0 |  0    0    0 |  0    0  3.5k   0 | 30   24k   0
  0  7.1k 1.5k|  0    0    0 |  0    0    0 |  0    0  3.5k   0 | 30   24k   0

[root@ceph-osd1 ceph-play]# ceph daemonperf osd.2
---objecter--- -----------osd-----------
writ read actv|recop rd   wr   lat  ops |
  0    0    0 |   0    0    0    0    0
  0    0    0 |   0    0    0    0    0
    
issues:
1. quote these numbers 
0755
0600
0644
0770
in "roles/ceph-common/tasks/main.yml", or ansible fail

2. need to manually enable and start mds service:
ln -s /usr/lib/systemd/system/ceph-mds\@.service /etc/systemd/system/multi-user.target.wants/ceph-mds@$HOSTNAME.service
systemctl enable ceph-mds@$HOSTNAME
systemctl start ceph-mds@$HOSTNAME

3. sometimes ceph.conf file in mds nodes does not contain the mon nodes' info.

4. mon nodes need to create /var/run/ceph/rbd-clients/, or socket bind_and_listen errors, not critical

To add OSD nodes (by Sébastien Han):
* ran 'ceph fsid' to pick up the uuid used and edited group_vars/{all,mons,osds} with it (var fsid)
* collected the monitor keyring here: /var/lib/ceph/mon/ceph-ceph-eno1/keyring and put it in group_vars/mons on monitor_secret
* configured the monitor_interface variable in group_vars/all, this one might be tricky make sure that ceph-deploy used the right interface beforehand
* change the journal_size variable in group_vars/all and used 5120 (ceph-deploy default)
* change the public_network and cluster_network variables in group_vars/all
* removed everything in ~./ceph-ansible/fetch
* configure ceph-ansible to use a dedicated journal (journal_collocation: false and raw_multi_journal: true and edited raw_journal_devices variable)

Eventually ran “ansible-playbook site.yml”

```   