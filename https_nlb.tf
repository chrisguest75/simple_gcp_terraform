resource "google_compute_managed_ssl_certificate" "default" {
  provider = "google-beta"

  name = "${var.endpoint_name}-cert-tf"

  managed {
    domains = ["${var.endpoint_name}.${var.domain_name}"]
  }
}

resource "google_compute_target_https_proxy" "default" {
  provider = "google-beta"

  name             = "demoserver-proxy-tf"
  url_map          = "${google_compute_url_map.default.self_link}"
  ssl_certificates = ["${google_compute_managed_ssl_certificate.default.self_link}"]
}

resource "google_compute_url_map" "default" {
  provider = "google-beta"

  name        = "url-map"
  description = "a description"

  default_service = "${google_compute_backend_service.default.self_link}"

  host_rule {
    hosts        = ["${var.endpoint_name}.${var.domain_name}"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.default.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.default.self_link}"
    }
  }
}

resource "google_compute_backend_service" "default" {
  provider = "google-beta"

  name        = "backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = ["${google_compute_http_health_check.default.self_link}"]
}

resource "google_compute_http_health_check" "default" {
  provider = "google-beta"

  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_global_forwarding_rule" "default" {
  provider = "google-beta"

  name       = "forwarding-rule"
  target     = "${google_compute_target_https_proxy.default.self_link}"
  port_range = 443
}

