rm -fr ./ceph-ansible-master
if [ -f ./master.zip ]; then
    unzip master.zip
else
    wget https://github.com/ceph/ceph-ansible/archive/master.zip
    unzip master.zip
fi

cat > ceph-ansible-master/group_vars/all <<EOF

fetch_directory: fetch/

mon_group_name: mons
osd_group_name: osds
mds_group_name: mdss

upgrade_ceph_packages: true

ceph_origin: 'upstream' # or 'distro'
ceph_stable: true # use ceph stable branch
ceph_stable_key: https://download.ceph.com/keys/release.asc
ceph_stable_release: infernalis 

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

pool_default_size: 3
pool_default_min_size: 2

public_network:  10.0.15.0/24

enable_debug_mon: true

os_tuning_params:
  - { name: kernel.pid_max, value: 4194303 }
  - { name: fs.file-max, value: 26234859 }

EOF

cat > ceph-ansible-master/group_vars/osds <<EOF

devices:
  - /dev/sdb
  - /dev/sdc
  - /dev/sdd

osd_auto_discovery: false
journal_collocation: true

EOF

