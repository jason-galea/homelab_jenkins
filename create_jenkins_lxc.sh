#!/usr/bin/bash

ROOTFS_STORAGE=vms
ROOTFS_STORAGE_PATH="/tank/vms"

LXC_ID=182
LXC_HOSTNAME=jenkins-auto
LXC_ARCH=amd64
LXC_CORES=4
LXC_MEM=4096
LXC_SWAP=512
LXC_ROOTFS_SIZE=16G
LXC_NET_GW="10.1.1.1"
LXC_NET_IP="10.1.1.$LXC_ID"
# LXC_NET="name=eth0,bridge=vmbr0,firewall=1,gw=$LXC_NET_GW,hwaddr=46:54:F4:A0:18:ED,ip=$LXC_NET_IP/24,type=veth"
LXC_NET="name=eth0,bridge=vmbr0,firewall=1,gw=$LXC_NET_GW,ip=$LXC_NET_IP/24,type=veth"
LXC_FEATURES="nesting=1"


echo -e "\n==> Search for latest debian CT template"
LATEST_DEBIAN_TEMPLATE=$(
    pveam available --section system \
        | sed 's|system\ *||' | grep debian | sort | tail -n1
)
echo -e "\n==> Download CT template '$LATEST_DEBIAN_TEMPLATE'"
pveam download local $LATEST_DEBIAN_TEMPLATE


echo -e "\n==> Create new LXC container"
pct create \
    $LXC_ID \
    local:vztmpl/$LATEST_DEBIAN_TEMPLATE \
    --hostname $LXC_HOSTNAME \
    --arch $LXC_ARCH \
    --cores $LXC_CORES \
    --memory $LXC_MEM \
    --swap $LXC_SWAP \
    --storage $ROOTFS_STORAGE \
    --net0 $LXC_NET \
    --features $LXC_FEATURES


echo -e "\n==> Resize root FS"
pct resize $LXC_ID rootfs $LXC_ROOTFS_SIZE


echo -e "\n==> (DEBUG) Show new container config"
cat /etc/pve/lxc/$LXC_ID.conf


echo -e "\n==> Start new container"
pct start $LXC_ID


# echo -e "\n==> Wait for container to start"
while true; do
    if [[ $(lxc-info $LXC_ID | grep RUNNING) == "" ]]; then
        echo "==> Container not yet started, waiting 3 seconds..."
        sleep 3
    else
        echo "==> Container started successfully!"
        break
    fi
done



echo -e "\n==> Copy jenkins install script to container & run"
cp ./install_jenkins_from_lxc.sh $ROOTFS_STORAGE_PATH/subvol-$LXC_ID-disk-0/root/
pct exec $LXC_ID ./install_jenkins_from_lxc.sh

