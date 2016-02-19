#!/bin/bash

yum install -y unzip

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

fsid: "c5f1483a-4cf6-4d7f-9c64-d1de2a245686"
cephx: true
cephx_require_signatures: false # Kernel RBD does NOT support signatures!
cephx_cluster_require_signatures: false
cephx_service_require_signatures: false
rbd_default_format: 2

monitor_interface: enp0s8
monitor_secret: "AQDyeLtWAAAAABAASo+WI6kCgFX3oLai51z/IQ=="

journal_size: 2048

pool_default_pg_num: 64
pool_default_pgp_num: 64

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

sed -i 's+0755+\"0755\"+g' ceph-ansible-master/roles/ceph-common/tasks/main.yml
sed -i 's+0600+\"0600\"+g' ceph-ansible-master/roles/ceph-common/tasks/main.yml
sed -i 's+0644+\"0644\"+g' ceph-ansible-master/roles/ceph-common/tasks/main.yml
sed -i 's+0770+\"0770\"+g' ceph-ansible-master/roles/ceph-common/tasks/main.yml

cat >> ceph-ansible-master/roles/ceph-mds/tasks/pre_requisite.yml <<EOF
  failed_when: false

- name: enable systemd unit file for mds instance (for or after infernalis)
  file:
    src: /usr/lib/systemd/system/ceph-mds@.service
    dest: /etc/systemd/system/multi-user.target.wants/ceph-mds@{{ ansible_hostname }}.service
    state: link
  changed_when: false
  failed_when: false
  when:
    ansible_distribution != "Ubuntu" and
    is_ceph_infernalis

- name: start and add that the mds service to the init sequence (for or after infernalis)
  service:
      name: ceph-mds@{{ ansible_hostname }}
      state: started
      enabled: yes
  changed_when: false
  when:
    ansible_distribution != "Ubuntu" and
    is_ceph_infernalis

EOF
