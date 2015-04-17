#!/usr/bin/env bash

echo "******* JAVA_HOME = $JAVA_HOME"
echo "******* HOSTNAME = $1"

BLUEPRINT_URL="http://$1:8080/api/v1/blueprints/hive-test"
echo $BLUEPRINT_URL

CLUSTER_URL="http://$1:8080/api/v1/clusters/hive-test"
echo $CLUSTER_URL

HDP_REPO_URL="http://$1:8080/api/v1/stacks/HDP/versions/2.2/operating_systems/redhat6/repositories/HDP-2.2"
echo $HDP_REPO_URL

HDP_UTIL_REPO_URL="http://$1:8080/api/v1/stacks/HDP/versions/2.2/operating_systems/redhat6/repositories/HDP-UTILS-1.1.0.20"
echo $HDP_UTIL_REPO_URL

# register ambari blueprint
curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d @/vagrant/vagrant/blueprint.json -u admin:admin $BLUEPRINT_URL

# use custom/local repo
curl --silent --show-error -H "X-Requested-By: ambari" -X PUT -d @/vagrant/vagrant/hdp-repo.json -u admin:admin $HDP_REPO_URL
curl --silent --show-error -H "X-Requested-By: ambari" -X PUT -d @/vagrant/vagrant/hdp-util-repo.json -u admin:admin $HDP_UTIL_REPO_URL

# create cluster
curl --silent --show-error -H "X-Requested-By: ambari" -X POST -d @/vagrant/vagrant/create-cluster.json -u admin:admin $CLUSTER_URL
