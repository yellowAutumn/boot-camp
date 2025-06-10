# This file contains the configuration for deploying a web application to Google Cloud Run.

resource "google_cloud_run_v2_service" "default" {
  name     = "customer-web-app"
  location = "us-central1"

  template {
    containers {
        image = "gcr.io/pr-db-fn-1/customer-app"
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.bootcamp_project_id
  location = "us-central1"
  name     = "customer-web-app"

  role   = "roles/run.invoker"
  member = "allUsers"
}
