HOSTNAME = "hivetest.hdp.local"
IP = "192.168.66.101"

$hostsFile = <<SCRIPT
cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

$1  $2
EOF
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "chef/centos-6.6"

  config.vm.provision "shell", inline: $hostsFile, args: [IP, HOSTNAME]

  config.vm.provision "base", type: "shell", path: "provision-base.sh"

  config.vm.provision "ambari", type: "shell", path: "provision-ambari.sh", args: [HOSTNAME]

  config.vm.provision "cluster", type: "shell", path: "provision-cluster.sh"

  config.vm.hostname = HOSTNAME

  config.vm.network "private_network", ip: IP

  config.multihostsupdater.aliases = {IP => [HOSTNAME]}

  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 4
    v.name = HOSTNAME
  end
end