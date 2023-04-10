#!/bin/bash
#
#	Installationsscript Modul 145 - Netzwerk betreiben und erweitern

# Introseite 
bash -x /opt/lernmaas/helper/intro

# GNS3 Labor
cd /tmp
curl https://raw.githubusercontent.com/GNS3/gns3-server/master/scripts/remote-install.sh > gns3-remote-install.sh
sudo bash gns3-remote-install.sh

# Ubuntu Cloud-Image holen und aufbereiten u.a. fuer LernMAAS
sudo apt-get install -y genisoimage
sudo wget -O /opt/gns3/images/QEMU/jammy-server-cloudimg-amd64.img https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
sudo qemu-img resize /opt/gns3/images/QEMU/jammy-server-cloudimg-amd64.img +6G

# Netzwerk Bridge damit das Netzwerk schneller mit GNS3 funktioniert
sudo apt-get install -y bridge-utils net-tools
export ETH=$(ip link | awk -F: '$0 !~ "lo|vir|wl|tap|br|wg|docker0|^[^0-9]"{print $2;getline}')
export ETH=$(echo $ETH | sed 's/ *$//g')

cat <<EOF | sudo tee /etc/netplan/50-cloud-init.yaml
network:
    version: 2
    ethernets:
        ${ETH}:
            dhcp4: false
            dhcp6: false
    bridges:
      br0:
       dhcp4: true
       interfaces:
         - ${ETH}
EOF

sudo sed -i -e 's/MACAddressPolicy=persistent/MACAddressPolicy=none/g' /usr/lib/systemd/network/99-default.link

sudo netplan generate
sudo netplan apply 
