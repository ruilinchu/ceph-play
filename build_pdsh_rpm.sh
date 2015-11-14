#! /bin/sh
version=2.29
wget https://pdsh.googlecode.com/files/pdsh-$version.tar.bz2
yum install -y gcc rpm-build readline-devel ncurses-devel pam-devel
## error building with root
runuser -l vagrant -c "rpmbuild -ta /vagrant/pdsh-$version.tar.bz2"
yum install -y /home/vagrant/rpmbuild/RPMS/x86_64/pdsh-*.rpm
