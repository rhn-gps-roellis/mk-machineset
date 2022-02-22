#!/bin/bash

# Cleaning out old outdir
rm -rf ./out

# Output of: oc get -o jsonpath='{.status.infrastructureName}' infrastructure cluster 
clusterid="cluster2-79bxd"

# AWS Region and zone  and AMI info
region="us-east-1"
zones=(us-east-1a us-east-1b us-east-1c)
ami="ami-00e472e63fc0dbe01"

# vSphere datacenter, datastore and server info
datacenter="Datacenter"
datastore="datastore1"
vspheresrv="vsphere.example.com"
vmnetwork="VM Network"

# Create the outdir
mkdir -p ./out/

###
case "$1" in
	vsphere45)
		echo -n "Creating MachineSet manifests (vSphere45)..."
		templatefile=./templates/99_openshift-cluster-api_infra-machineset-TEMPLATE-vmw45.yaml
		[[ ! -e ${templatefile} ]] && echo "FATAL: ${templatefile} not found" && exit
		export CLUSTERID=${clusterid}
		export DATACENTER=${datacenter}
		export DATASTORE=${datastore}
		export VSPHERE_SERVER=${vspheresrv}
		export VM_NETWORK=${vmnetwork}
		envsubst < ${templatefile} > ./out/99_openshift-cluster-api_infra-machineset-0.yaml
		echo "DONE, manifests should be under ./out - Make sure to change the properties if you don't want a 4x16 server"
	;;
	vsphere48)
		echo -n "Creating MachineSet manifests (vSphere48)..."
		templatefile=./templates/99_openshift-cluster-api_infra-machineset-TEMPLATE-vmw48.yaml
		[[ ! -e ${templatefile} ]] && echo "FATAL: ${templatefile} not found" && exit
		export CLUSTERID=${clusterid}
		export DATACENTER=${datacenter}
		export DATASTORE=${datastore}
		export VSPHERE_SERVER=${vspheresrv}
		export VM_NETWORK=${vmnetwork}
		envsubst < ${templatefile} > ./out/99_openshift-cluster-api_infra-machineset-0.yaml
		echo "DONE, manifests should be under ./out - Make sure to change the properties if you don't want a 4x16 server"
	;;
	aws)
		templatefile=./templates/99_openshift-cluster-api_infra-machineset-TEMPLATE.yaml
		[[ ! -e ${templatefile} ]] && echo "FATAL: ${templatefile} not found" && exit
		echo -n "Creating MachineSet manifests (AWS)..."
		for zone in ${!zones[*]}
		do
			export CLUSTERID=${clusterid}
			export REGION=${region}
			export ZONE=${zones[${zone}]}
			export AMI=${ami}
			envsubst < ${templatefile} > ./out/99_openshift-cluster-api_infra-machineset-${zone}.yaml
		done
		echo "DONE, manifests should be under ./out - Make sure to change the instance type if you don't want m4.2xlarge"
	;;
	*)
		echo "Usage: $(basename $0) [vsphere45|vsphere48|aws]"
		exit 1
	;;
esac
##
##
