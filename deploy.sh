#!/bin/bash
yum install epel-release -y
yum install ansible unzip -y
cat > /etc/ansible/hosts <<EOF 

[mons]
chunk[1:3]

[osds]
chunk[1:3]

[mdss]
chunk3

EOF

cat >> /etc/hosts <<EOF

10.0.15.11 chunk1
10.0.15.12 chunk2
10.0.15.13 chunk3

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

wget https://github.com/ceph/ceph-ansible/archive/master.zip
unzip master.zip
./edit_ceph-ansible-master.sh

ansible-playbook ceph-ansible-master/site.yml
ansible-playbook ceph-ansible-master/site.yml

## expect to run site.yml mulltiple times



