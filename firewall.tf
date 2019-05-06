resource "google_compute_firewall" "default" {
  name = "demoserver-firewall-tf"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags = ["http-server", "https-server"]

  source_ranges = ["0.0.0.0/0"]

}
