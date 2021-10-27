#!/bin/bash
#
#	Installationsscript Modul 145 - Netzwerk betreiben und erweitern

sudo add-apt-repository ppa:gns3/ppa -y
sudo apt-update
export DEBIAN_FRONTEND=noninteractive
sudo apt install gns3-server gns3-gui  -y

# Introseite (= README dieses Repository)
bash -x /opt/lernmaas/helper/intro
