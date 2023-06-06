
module "lerncloud" {
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  
  module     = "m145"
  description = "Modul 145 Netzwerk betreiben und erweitern"
  cores   = 2
  memory  = 4
  storage = 24   
    
  userdata    = "cloud-init.yaml"
}
