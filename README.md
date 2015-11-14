# ceph-play

```
vagrant up
vagrant ssh chunk1
cd /vagrant
sudo su
./deploy.sh
./test.sh

install pdsh and run test

pdsh -w chunk[1-3] < test

```