# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile generated by https://github.com/timveil/hdp-vagrant-generator on 5/17/15 10:23 AM



Vagrant.configure("2") do |config|
    config.vm.box = "timveil/centos6.6-hdp-base"

    config.vm.box_check_update = true

    config.vbguest.auto_update = true

    config.vbguest.no_remote = true

    config.vbguest.no_install = false

    config.multihostsupdater.aliases = {'192.168.66.101' => ['hivetest.hdp.local']}

    config.vm.provision "hosts", type: "shell", inline: $hostsFile

    config.vm.provision "logCleanup", type: "shell", inline: $logCleanup, run: "always"

    config.vm.provision "build", type: "shell", inline: $build

    config.vm.provision "checkStatus", type: "shell", path: "vagrant-checkstatus.sh"

    config.vm.hostname = 'hivetest.hdp.local'

    config.vm.network "private_network", ip: '192.168.66.101'

    config.vm.provider "virtualbox" do |v|
        v.memory = 8192
        v.cpus = 4
        v.name = 'hivetest.hdp.local'
    end
end

$hostsFile = <<SCRIPT

cat > /etc/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.66.101   hivetest.hdp.local
192.168.66.10   repo.hdp.local
EOF

SCRIPT

$logCleanup = <<SCRIPT

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Cleaning Logs"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

rm -rf /var/log/ambari-metrics-collector/*
rm -rf /var/log/ambari-metrics-monitor/*
rm -rf /var/log/falcon/*
rm -rf /var/log/flume/*
rm -rf /var/log/hadoop/hdfs/*
rm -rf /var/log/hadoop/mapreduce/*
rm -rf /var/log/hadoop/yarn/*
rm -rf /var/log/hadoop-mapreduce/mapred/*
rm -rf /var/log/hadoop-yarn/yarn/*
rm -rf /var/log/hadoop-yarn/nodemanager/*
rm -rf /var/log/hadoop-httpfs/*
rm -rf /var/log/hbase/*
rm -rf /var/log/hive/*
rm -rf /var/log/kafka/*
rm -rf /var/log/knox/*
rm -rf /var/log/oozie/*
rm -rf /var/log/ranger/*
rm -rf /var/log/sqoop/*
rm -rf /var/log/storm/*
rm -rf /var/log/webhcat/*
rm -rf /var/log/zookeeper/*

rm -rf /tmp/hive/*
rm -rf /tmp/hcat/*
rm -rf /tmp/ambari-qa/*
rm -rf /tmp/root/*

SCRIPT

$build = <<SCRIPT

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Cleaning YUM"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

yum clean all


echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Deleting YUM History"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

yum history new

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Getting Ambari YUM Repo from http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.0.0/ambari.repo"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

wget -q http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Installing Ambari Server and Agent"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

yum install ambari-server ambari-agent unzip -y -q

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Updating Ambari Agent Hostname"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

sed -i "s/^hostname=localhost/hostname=hivetest.hdp.local/g" /etc/ambari-agent/conf/ambari-agent.ini

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Downloading New MySQL Connector Jar"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

wget -q http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.zip -O /usr/share/java/mysql-connector-java-5.1.35.zip
cd /usr/share/java
unzip -q mysql-connector-java-5.1.35.zip

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Running Ambari Server setup"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

ambari-server setup -s -j $JAVA_HOME

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Updating MySql Connector Jar"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

ambari-server setup --jdbc-driver=/usr/share/java/mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar --jdbc-db=mysql

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Downloading Ambari Files View"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

wget -q http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Views/tp1/files-0.1.0-tp1.jar -O /var/lib/ambari-server/resources/views/files-0.1.0-tp1.jar

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Downloading Ambari Hive View"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

wget -q http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Views/tp1/hive-0.2.0-tp1.jar -O /var/lib/ambari-server/resources/views/hive-0.2.0-tp1.jar

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Starting Ambari Server"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

ambari-server start

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Starting Ambari Agent"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

ambari-agent start

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Executing POST to Create Blueprint"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d '{"configurations": [{"hdfs-site": {"properties": {"dfs.replication": "1"}}},{"core-site": {"properties": {"hadoop.proxyuser.root.groups": "*","hadoop.proxyuser.root.hosts": "*","hadoop.proxyuser.hcat.groups": "*","hadoop.proxyuser.hcat.hosts": "*"}}},{"webhcat-site": {"properties": {"webhcat.proxyuser.root.groups": "*","webhcat.proxyuser.root.hosts": "*"}}},{"hive-site": {"properties": {"javax.jdo.option.ConnectionUserName": "hive","javax.jdo.option.ConnectionPassword": "hive"}}},{"mapred-site": {"properties": {"mapreduce.map.java.opts": "-Xmx614m","mapreduce.map.memory.mb": "768","mapreduce.reduce.java.opts": "-Xmx1228m","mapreduce.reduce.memory.mb": "1536","yarn.app.mapreduce.am.command-opts": "-Xmx1228m -Dhdp.version=${hdp.version}","yarn.app.mapreduce.am.resource.mb": "1536"}}},{"yarn-site": {"properties": {"yarn.nodemanager.resource.memory-mb": "6144","yarn.scheduler.maximum-allocation-mb": "6144","yarn.scheduler.minimum-allocation-mb": "768"}}}],"host_groups": [{"name": "host_group_1","configurations": [],"components": [{"name": "AMBARI_SERVER"},{"name": "APP_TIMELINE_SERVER"},{"name": "DATANODE"},{"name": "HCAT"},{"name": "HDFS_CLIENT"},{"name": "HISTORYSERVER"},{"name": "HIVE_CLIENT"},{"name": "HIVE_METASTORE"},{"name": "HIVE_SERVER"},{"name": "MAPREDUCE2_CLIENT"},{"name": "METRICS_COLLECTOR"},{"name": "METRICS_MONITOR"},{"name": "MYSQL_SERVER"},{"name": "NAMENODE"},{"name": "NODEMANAGER"},{"name": "PIG"},{"name": "RESOURCEMANAGER"},{"name": "SECONDARY_NAMENODE"},{"name": "TEZ_CLIENT"},{"name": "WEBHCAT_SERVER"},{"name": "YARN_CLIENT"},{"name": "ZOOKEEPER_CLIENT"},{"name": "ZOOKEEPER_SERVER"}],"cardinality": "1"}],"Blueprints": {"blueprint_name": "custom-generated-blueprint","stack_name": "HDP","stack_version": "2.2"}}' -u admin:admin http://hivetest.hdp.local:8080/api/v1/blueprints/custom-generated-blueprint



echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Executing POST to Create Files View"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d '{"ViewInstanceInfo":{"instance_name":"Files","label":"Files","visible":true,"icon_path":"","icon64_path":"","properties":{"webhdfs.url":"webhdfs://hivetest.hdp.local:50070","webhdfs.username":null,"webhdfs.auth":"auth=SIMPLE"},"description":"Files"}}' -u admin:admin http://hivetest.hdp.local:8080/api/v1/views/FILES/versions/0.1.0/instances/Files

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Executing POST to Create Jobs View"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d '{"ViewInstanceInfo":{"instance_name":"Jobs","label":"Jobs","visible":true,"icon_path":"","icon64_path":"","properties":{"yarn.ats.url":"http://hivetest.hdp.local:8188","yarn.resourcemanager.url":"http://hivetest.hdp.local:8088"},"description":"Jobs"}}' -u admin:admin http://hivetest.hdp.local:8080/api/v1/views/JOBS/versions/1.0.0/instances/Jobs

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Executing POST to Create Hive View"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d '{"ViewInstanceInfo":{"instance_name":"Hive","label":"Hive","visible":true,"icon_path":"","icon64_path":"","properties":{"webhdfs.url":"webhdfs://hivetest.hdp.local:50070","webhdfs.username":null,"webhdfs.auth":"auth=SIMPLE","dataworker.username":null,"scripts.dir":"/user/${username}/hive/scripts","jobs.dir":"/user/${username}/hive/jobs","hive.host":"hivetest.hdp.local","hive.port":"10000","hive.auth":"auth=NONE","yarn.ats.url":"http://hivetest.hdp.local:8188"},"description":"Hive"}}' -u admin:admin http://hivetest.hdp.local:8080/api/v1/views/HIVE/versions/0.2.0/instances/Hive

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Executing POST to Create Tez View"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d '{"ViewInstanceInfo":{"instance_name":"Tez","label":"Tez","visible":true,"icon_path":"","icon64_path":"","properties":{"yarn.timeline-server.url":"http://hivetest.hdp.local:8188","yarn.resourcemanager.url":"http://hivetest.hdp.local:8088"},"description":"Tez"}}' -u admin:admin http://hivetest.hdp.local:8080/api/v1/views/TEZ/versions/0.5.2.2.2.2.0-151/instances/Tez

echo " "
echo "---------------------------------------------------------------------------------------------------------------"
echo "----- Executing POST to Install Cluster"
echo "---------------------------------------------------------------------------------------------------------------"
echo " "

curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d '{"blueprint" : "custom-generated-blueprint","default_password" : "password","host_groups" :[{"name" : "host_group_1","hosts" : [{"fqdn" : "hivetest.hdp.local"}]}]}' -u admin:admin http://hivetest.hdp.local:8080/api/v1/clusters/hive-test

SCRIPT