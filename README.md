# Modul 145 Netzwerk betreiben und erweitern

### Kompetenz

Performance und Verfügbarkeit eines Netzwerks überwachen und Ergebnisse interpretieren. Netzwerke nach Vorgabe mit WLAN /VLAN erweitern und entfernte lokale Netze sicher verbinden.

### Objekt

Zwei lokale Netze, SNMP/VLAN fähige Netzwerkgeräte, WLAN Komponenten.

### Infrastruktur (GNS3)

Graphical Network Simulator-3 ist ein Netzwerk-Software-Emulator, der erstmals 2008 veröffentlicht wurde. Er ermöglicht die Kombination von virtuellen und realen Geräten, die zur Simulation komplexer Netzwerke verwendet werden.

Das ist nicht die offizielle GNS3 Umgebung der TBZ, sondern nur eine abgespekte Variante um via Weboberfläche ein paar Layouts erzeugen zu können. Es fehlt IOU. OpenVPN funktioniert nur über WireGuard (d.h. zuerst WireGuard aktivieren, dann OpenVPN). Zugriffsinformationen für OpenVPN, siehe Tab ACCESSING.

Für die offizielle GNS3 TBZ Umgebung siehe [hier](https://gitlab.com/ch-tbz-it/Stud/allgemein/tbzcloud-gns3).

Für vorbereite Projeke siehe [hier](https://github.com/mc-b/lerngns3/tree/main/projects#gns3-projekte). Brauchen Nested Virtualization!

**Netzwerke**

* 192.168.23.0/24 - Management Netzwerk ohne Verbindung ins Internet. GNS3 Device Cloud, Anschluss br0
* 192.168.122.0/24 - NAT Anschluss mit Verbindungs ins Internet. GNS3 Device NAT.

**Zugriff auf GNS3 Weboberfläche**

  [http://${ADDR}:3080](http://${ADDR}:3080)
  
### Feintuning
  
**Hyper-V mit Windows und Multipass**

Ist Nested Virtualization (VM in VM) zu aktivieren.

Dazu sind folgende Schritte, in der PowerShell als Administrator, notwendig
* VM stoppen, z.B. mittels Hyper-V Manager oder Multipass 
* Nested Virtualization aktivieren
* VM starten und ggf. IP-Adresse überprüfen.

Die Befehle sind wie folgt: 

    multipass stop gns3-60-default
    Set-VMProcessor -VMName gns3-60-default -ExposeVirtualizationExtensions $true
    Get-VMNetworkAdapter -VMName gns3-60-default | Set-VMNetworkAdapter -MacAddressSpoofing On
    multipass start gns3-60-default
    
Um die VM für Hyper-V zu optimieren, sollte der Azure Kernel installiert werden.

    multipass shell gns3-60-default
    sudo apt-get -y update
    sudo apt-get -y install linux-azure
    sudo shutdown -r now
    
* [Ubuntu für Hyper-V optimieren](https://blog.daniel.wydler.eu/2020/09/20/ubuntu-20-04-lts-fuer-hyper-v-optimieren/)            
    
**Azure, AWS Cloud**

Ist entweder eine [Bare Metal Instanz](https://aws.amazon.com/de/about-aws/whats-new/2021/11/amazon-ec2-bare-metal-instances/) mit dem Cloud-init Script [cloud-init.yaml](cloud-init.yaml) zu verwenden.

Oder die KVM Unterstützung zu deaktivieren. Dazu die Konfigurationsdatei `/opt/gns3/.config/GNS3/2.2/gns3_server.conf` um folgenden Eintrag ergänzen:

    [Qemu]
    enable_kvm = false    
  
## Links

* [Modulbeschreibung von ICT Berufsbildung](https://www.modulbaukasten.ch/module/145/3/de-DE?title=Netzwerk-betreiben-und-erweitern)
* [GNS3 Homepage](https://www.gns3.com/)
* [GNS3 Dokumentation](https://docs.gns3.com/docs/)
* [GNS3 Appliances](https://gns3.com/marketplace/appliances)

