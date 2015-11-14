#! /bin/sh
version=2.29
wget https://pdsh.googlecode.com/files/pdsh-$version.tar.bz2
yum install -y gcc rpm-build readline-devel ncurses-devel pam-devel
rpmbuild -ta pdsh-$version.tar.bz2
yum install -y ~/rpmbuild/RPMS/x86_64/pdsh-*.rpm
