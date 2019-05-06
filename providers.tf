
provider "google" {
  credentials = "${file("${var.keyfile}")}"    
  project = "${var.project_name}"
  zone  = "${var.region_a_zone}"
}




