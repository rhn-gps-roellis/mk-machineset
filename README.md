# Create Infra Node Machine Sets

Quick and Dirty shell script to create machinesets as seen on the Infra Node [Twitch Stream](https://youtu.be/9VNjDh1vPXI?t=3552)

> :rotating_light: This script was originally developed for OCP 4.5, and is now updated to support OCP 4.8 on Vsphere.

## Setup 

Edit this script with your variables depending on your env

### AWS


```shell
clusterid="cluster2-79bxd"
region="us-east-1"
zones=(us-east-1a us-east-1b us-east-1c)
ami="ami-00e472e63fc0dbe01"
```

* `clusterid` is the output of `oc get -o jsonpath='{.status.infrastructureName}' infrastructure cluster`
* `region` is the AWS region your cluster is in
* `zones` is an array of the AWS zones you want your infra node to be in.
* `ami` is the name of the AWS ami of RHCOS

### vSphere45 and vSphere48

```shell
clusterid="cluster2-79bxd"
datacenter="Datacenter"
datastore="datastore1"
vspheresrv="vsphere.example.com"
vmnetwork="VM Network"
```

* `clusterid` is the output of `oc get -o jsonpath='{.status.infrastructureName}' infrastructure cluster`
* `datacenter` is the name of your datacenter
* `datastore` is the name of the datastore you want the VMs to be installed on
* `vspheresrv` is the hostname of your vSphere/vCenter endpoint.
* `vmnetwork` is the name of the network that your Vsphere VMs will live on


## Run

Run the script for AWS

```shell
./mk-machineset.sh
```

Run the script for vSphere45

```shell
./mk-machineset.sh vsphere45
```

Run the script for vSphere48

```shell
./mk-machineset.sh vsphere48
```

## Apply

Apply the manifest

> :warning:  modify the files if you want to change the type of server.

```shell
oc apply -f ./out/
```

## SLA

I make no guarantees for this QnD script, so YMMV. Use caution.
