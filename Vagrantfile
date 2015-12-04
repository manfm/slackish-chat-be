# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 9200, host: 9200

  config.vm.provision "shell", path: "provision.sh", privileged: true
  config.vm.provision "shell", path: "provision-rvm.sh", args: "stable", privileged: false
  config.vm.provision "shell", path: "provision-ruby.sh", privileged: false

  config.vm.provider "virtualbox" do |v|
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
end

#rails new travel
#rails generate controller Trip sendFavorite
