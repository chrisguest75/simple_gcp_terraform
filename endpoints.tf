
resource "google_project_service" "endpoints" {
  project = "${var.project_id}"  
  service = "endpoints.googleapis.com"
 }


resource "google_endpoints_service" "default" {
  service_name   = "${var.endpoint_name}.endpoints.${var.project_name}.cloud.goog"
  openapi_config = "${data.template_file.open-api-template.rendered}"

  depends_on     = ["google_project_service.endpoints"]

}

data "template_file" "open-api-template" {
  template = "${file("./simple_api_server/openapi/service_api.template.yaml")}"

  vars {
    service_name = "${var.endpoint_name}.endpoints.${var.project_name}.cloud.goog"
    ip_address = "${google_compute_global_address.default.address}"
    #ip_address = "35.241.17.203"
  }
}

