
provider "google" {
  credentials = "${file("./manual-terraform-sa.json")}"    
  #credentials = "${file("./simple-terraform-01-e07ecc346c62.json")}"    
  #credentials = "${file("./simple-terraform-01-a961aed52c7d.json")}"    

  
  project = "open-source-01"
  #region  = "europe-west1"
  zone    = "europe-west1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-1810-cosmic-v20190502"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config = {
    }
  }

  #network_interface {
  #  # A default network is created for all GCP projects
  #  network       = "${google_compute_network.vpc_network.self_link}"
  #  access_config = {
  #  }
  #}
}
#resource "google_compute_network" "vpc_network" {
#  name                    = "terraform-network"
#  auto_create_subnetworks = "true"
#}
