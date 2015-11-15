#!/bin/sh

yum -y update
rpm -Uhv http://ceph.com/rpm-hammer/el7/noarch/ceph-release-1-1.el7.noarch.rpm
yum -y install epel-release
yum -y install ntp snappy leveldb gdisk python-argparse gperftools-libs python-pycurl hdparm yum-plugin-priorities.noarch
yum -y install ceph ceph-deploy --disablerepo=epel
systemctl enable ntpd

yum clean all
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

cat /dev/null > ~/.bash_history && history -c && exit

# vagrant package --output mynew.box
# vagrant box add mynewbox mynew.box
