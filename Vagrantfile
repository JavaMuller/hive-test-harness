HOSTNAME = "hivetest.hdp.local"

Vagrant.configure("2") do |config|
  config.vm.box = "chef/centos-6.6"

  config.vm.provision "base", type: "shell", path: "provision-base.sh"

  config.vm.provision "ambari", type: "shell", path: "provision-ambari.sh", args: HOSTNAME

  config.vm.provision "cluster", type: "shell", path: "provision-cluster.sh"

  config.vm.hostname = HOSTNAME

  config.vm.network "private_network", ip: "192.168.66.101"

  config.multihostsupdater.aliases = ["hivetest"]

  config.vbguest.no_remote = true

  config.vbguest.auto_update = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 4
    v.name = HOSTNAME
  end
end