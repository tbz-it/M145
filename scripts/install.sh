#!/bin/bash
#
#	Installationsscript Modul 145 - Netzwerk betreiben und erweitern

# Introseite 
bash -x /opt/lernmaas/helper/intro

# GNS3 Labor
cd /tmp
curl https://raw.githubusercontent.com/GNS3/gns3-server/master/scripts/remote-install.sh > gns3-remote-install.sh
sudo bash gns3-remote-install.sh --without-kvm
