#! /bin/sh
version=2.29
if ls ./pdsh_el7/pdsh*.rpm 1> /dev/null 2>&1; then
    echo "installing rpm"
    yum -y install ./pdsh_el7/pdsh*.rpm
else
    wget https://pdsh.googlecode.com/files/pdsh-$version.tar.bz2
    yum install -y gcc rpm-build readline-devel ncurses-devel pam-devel
    ## error building with root
    runuser -l vagrant -c "rpmbuild -ta /vagrant/pdsh-$version.tar.bz2"
    yum install -y /home/vagrant/rpmbuild/RPMS/x86_64/pdsh-*.rpm
    mkdir -p pdsh_el7
    cp -r /home/vagrant/rpmbuild/RPMS/x86_64/pdsh-*.rpm pdsh_el7/
fi
