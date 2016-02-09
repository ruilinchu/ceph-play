# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # create some ceph-mon servers, each with two additional disks
  (1..3).each do |i|
    config.vm.define "ceph-mon#{i}" do |node|
      node.vm.box = "box-cutter/centos71"
      #        node.vm.box = "centos71_ceph"
      node.vm.hostname = "ceph-mon#{i}"
      node.vm.network :private_network, ip: "10.0.15.1#{i}"
      #       node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "750"
      end
    end
  end

  # create some ceph-osd servers, each with two additional disks
  (1..3).each do |i|
    config.vm.define "ceph-osd#{i}" do |node|
      node.vm.box = "box-cutter/centos71"
      #        node.vm.box = "centos71_ceph"
      node.vm.hostname = "ceph-osd#{i}"
      node.vm.network :private_network, ip: "10.0.15.2#{i}"
      #       node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "750"
        (0..2).each do |d|
          vb.customize ['createhd',
                        '--filename', "osd-disk-#{i}-#{d}",
                        '--size', '11000']
          # Controller names are dependent on the VM being built.
          # It is set when the base box is made in our case box-cutter/centos71.
          # Be careful while changing the box.
          vb.customize ['storageattach', :id,
                        '--storagectl', 'SATA Controller',
                        '--port', 3 + d,
                        '--device', 0,
                        '--type', 'hdd',
                        '--medium', "osd-disk-#{i}-#{d}.vdi"]
        end
        
      end
    end
  end

  # create some ceph-mds servers, each with two additional disks
  (1..2).each do |i|
    config.vm.define "ceph-mds#{i}" do |node|
      node.vm.box = "box-cutter/centos71"
      #        node.vm.box = "centos71_ceph"
      node.vm.hostname = "ceph-mds#{i}"
      node.vm.network :private_network, ip: "10.0.15.3#{i}"
      #       node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
    end
  end

end
