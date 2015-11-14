# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # create some chunk servers, each with two additional disks
   (1..3).each do |i|
    config.vm.define "chunk#{i}" do |node|
#      node.vm.box = "box-cutter/centos71"
        node.vm.box = "centos71_ceph"
        node.vm.hostname = "chunk#{i}"
        node.vm.network :private_network, ip: "10.0.15.1#{i}"
 #       node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "750"
          (0..2).each do |d|
            vb.customize ['createhd',
                          '--filename', "disk-#{i}-#{d}",
                          '--size', '11000']
            # Controller names are dependent on the VM being built.
            # It is set when the base box is made in our case box-cutter/centos71.
            # Be careful while changing the box.
            vb.customize ['storageattach', :id,
                          '--storagectl', 'SATA Controller',
                          '--port', 3 + d,
                          '--device', 0,
                          '--type', 'hdd',
                          '--medium', "disk-#{i}-#{d}.vdi"]
          end
          
        end
    end
  end
  
end
