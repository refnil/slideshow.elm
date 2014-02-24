# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$provision = <<SCRIPT
apt-get update -y
apt-get install cabal-install zlib1g-dev -y
cabal update
#cabal install alex happy --global
cabal install elm --global
cabal install elm-server --global
ln -fs /vagrant ./elm-folder
echo '#! /usr/bin/env bash' > /etc/init.d/elm-server
echo 'cd /home/vagrant/elm-server' >> /etc/init.d/elm-server
echo 'pwd' >> /etc/init.d/elm-server
echo 'elm-server &' >> /etc/init.d/elm-server
chmod +x /etc/init.d/elm-server
update-rc.d elm-server defaults
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu13.10"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-i386-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 8000, host: 8080

  config.vm.provision "shell", inline: $provision
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
end

