
resource "google_compute_region_instance_group_manager" "default" {
  name = "demoserver-instancegroup-tf"

  base_instance_name = "demoserver"
  instance_template  = "${google_compute_instance_template.default.self_link}"
  region               = "${var.region_a}"
  distribution_policy_zones  = [ "${var.region_a_zone}"]

  target_size  = 1

  named_port {
    name = "http"
    port = 80
  }

}

resource "google_compute_region_autoscaler" "default" {
  name   = "demoserver-autoscaler-tf"

  target = "${google_compute_region_instance_group_manager.default.self_link}"

  autoscaling_policy = {
    max_replicas    = 1
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }

  region = "${var.region_a}"
}
 
resource "google_compute_instance_template" "default" {
  name        = "demoserver-template-tf"
  description = "This template is used to create app server instances."

  tags = ["http-server", "https-server"]

  labels = {
    environment = "${var.endpoint_name}"
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

    access_config {
        nat_ip = ""
    }
  }

  metadata {
    "startup-script" = "${data.template_file.instance-startup-script.rendered}"
  }

  service_account {
    scopes = [
	"https://www.googleapis.com/auth/service.management.readonly",
	"https://www.googleapis.com/auth/logging.write",
	"https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/trace.append",
	"https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}

data "template_file" "instance-startup-script" {
  template = "${file("${path.module}/instance-startup-script.sh")}"

  vars {
    service_name = "${var.endpoint_name}.endpoints.${var.project_name}.cloud.goog"
  }
}

output "instance_group_manager" {
  value = "${google_compute_region_instance_group_manager.default.instance_group}"
}

