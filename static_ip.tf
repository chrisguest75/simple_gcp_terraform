


resource "google_compute_global_address" "default" {
  provider = "google-beta"
  name = "demoserver-externalip-tf"

  labels = {
    environment = "${var.endpoint_name}"
    terraform_managed = "true"
  }
}
output "ip-address" {
  value = "${google_compute_global_address.default.address}"
}


