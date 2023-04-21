#!/bin/bash
#
#	Installationsscript Modul 145 - Netzwerk betreiben und erweitern

# Introseite 
bash -x /opt/lernmaas/helper/intro

# GNS3 Labor
cd /tmp
curl https://raw.githubusercontent.com/GNS3/gns3-server/master/scripts/remote-install.sh > gns3-remote-install.sh
sudo bash gns3-remote-install.sh
sudo usermod -aG gns3 ubuntu

# Ubuntu Cloud-Image holen und aufbereiten u.a. fuer LernMAAS
sudo apt-get install -y genisoimage
sudo wget -O /opt/gns3/images/QEMU/jammy-server-cloudimg-amd64.img https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
sudo qemu-img resize /opt/gns3/images/QEMU/jammy-server-cloudimg-amd64.img +30G

# Templates anlegen
curl -X POST "http://localhost:3080/v2/templates" -d '{"name": "Ubuntu-22", "compute_id": "local", "qemu_path": "/usr/bin/qemu-system-x86_64", "hda_disk_image": "jammy-server-cloudimg-amd64.img", "symbol": ":/symbols/affinity/circle/gray/vm.svg", "ram": 2048, "template_type": "qemu"}' 
curl -X POST "http://localhost:3080/v2/templates" -d '{ "category": "guest", "compute_id": "local", "console_type": "vnc", "image": "gns3/webterm", "name": "webterm", "symbol": ":/symbols/affinity/circle/gray/client.svg", "template_type": "docker" }'
curl -X POST "http://localhost:3080/v2/templates" -d '{ "category": "guest", "compute_id": "local", "console_type": "vnc", "image": "jess/chromium", "name": "chromium", "symbol": ":/symbols/affinity/circle/gray/client.svg", "template_type": "docker" }'

# WebShop Templates
curl -sfL https://raw.githubusercontent.com/mc-b/gns3/master/scripts/gns3-webshop | bash -

# LernMAAS Template anlegen
curl -sfL https://raw.githubusercontent.com/mc-b/lernmaas/master/scripts/gns3-templates | bash -

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
