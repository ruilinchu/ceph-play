cat > ceph-ansible-master/group_vars/all <<EOF

fetch_directory: fetch/

mon_group_name: mons
osd_group_name: osds
mds_group_name: mdss

ceph_origin: 'upstream' # or 'distro'
ceph_stable: true # use ceph stable branch
ceph_stable_key: https://download.ceph.com/keys/release.asc
ceph_stable_release: hammer # ceph stable release

ceph_stable_redhat_distro: el7
ceph_dev_redhat_distro: centos7

cephx: true
cephx_require_signatures: false # Kernel RBD does NOT support signatures!
cephx_cluster_require_signatures: false
cephx_service_require_signatures: false
rbd_default_format: 2

monitor_interface: enp0s8

journal_size: 2048

pool_default_pg_num: 256
pool_default_pgp_num: 256

public_network:  10.0.15.0/24

EOF

cat > ceph-ansible-master/group_vars/osds <<EOF

osd_auto_discovery: true
journal_collocation: true

EOF

