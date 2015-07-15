# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder("..", "/home/web/wdcom", :owner => 'web')
  config.vm.box = "hashicorp/precise32"

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "basic"
  end

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 3001, host: 3001

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024", "--hwvirtex", "off"]
 end
end
