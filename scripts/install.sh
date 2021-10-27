#!/bin/bash
#
#	Installationsscript Modul 145 - Netzwerk betreiben und erweitern

sudo add-apt-repository ppa:gns3/ppa -y
sudo apt-update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q gns3-server gns3-gui

# Introseite (= README dieses Repository)
bash -x /opt/lernmaas/helper/intro
