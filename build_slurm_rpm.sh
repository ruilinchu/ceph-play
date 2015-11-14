#!/bin/sh
version=15.08.3
wget http://www.schedmd.com/download/latest/slurm-$version.tar.bz2
yum install -y  gcc gcc-c++ mailx make munge munge-devel munge-libs openssl openssl-devel pam-devel perl perl-ExtUtils-MakeMaker readline-devel rpm-build
rpmbuild -ta slurm-$version.tar.bz2
yum install -y ~/rpmbuild/RPMS/x86_64/slurm-*.rpm
