#!/bin/bash
yum install epel-release -y
yum install ansible -y

cat > /etc/ansible/hosts <<EOF 
[mons]
ceph-osd[1:3]

[osds]
ceph-osd[1:1]

[mdss]
ceph-osd[1:2]

EOF

cat >> /etc/hosts <<EOF

10.0.15.21 ceph-osd1
10.0.15.22 ceph-osd2
10.0.15.23 ceph-osd3
10.0.15.24 ceph-osd4

EOF

cat > /etc/profile.d/pdsh.sh <<EOF
export PDSH_RCMD_TYPE='ssh'
export WCOLL='/etc/pdsh/machines'
EOF

mkdir -p /etc/pdsh
grep 10.0. /etc/hosts | awk '{print $2}' > /etc/pdsh/machines

./build_pdsh_rpm.sh

ssh-keygen -t rsa
for i in `grep 10.0.15 /etc/hosts | awk '{print $2}'`; do
    ssh-keyscan $i;
done > ~/.ssh/known_hosts

ansible-playbook ssh_key.yml --ask-pass 

./edit_ceph-ansible-master.sh

cd ceph-ansible-master

cp site.yml.sample site.yml
ansible-playbook site.yml

#ansible-playbook site.yml

## expect to run site.yml mulltiple times



