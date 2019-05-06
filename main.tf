
provider "google" {
  credentials = "${file("${var.keyfile}")}"    
  project = "${var.project_name}"
  zone  = "${var.region_a_zone}"
}


resource "google_compute_instance_template" "default" {
  name        = "demoserver-template-tf"
  description = "This template is used to create app server instances."

  tags = ["http-server", "https-server"]

  labels = {
    environment = "dev"
    docker = "true"
    webserver = "true"
    terraform_managed = "true"
  }

  instance_description = "Used for hosting docker containers for endpoints"
  machine_type         = "f1-micro"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "ubuntu-minimal-1804-bionic-v20190429"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
  }

  metadata {
    "startup-script" = "${data.template_file.instance-startup-script.rendered}"
  }

  lifecycle {
    create_before_destroy = true
  }  
}

data "template_file" "instance-startup-script" {
  template = "${file("${path.module}/instance-startup-script.sh")}"

  vars {
    service_name = "${var.endpoint_name}.endpoints.${var.project_name}.cloud.goog"
  }
}

