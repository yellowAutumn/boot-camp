# This file contains the configuration for deploying a web application to Google Cloud Run.

resource "google_cloud_run_v2_service" "customer_webapp" {
  name     = "customer-web-app"
  location = var.region

  template {
    containers {
      image = "gcr.io/pr-db-fn-1/customer-app"
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "customer_webapp_iam_member" {
  project  = var.bootcamp_project_id
  location = google_cloud_run_v2_service.customer_webapp.location
  name     = google_cloud_run_v2_service.customer_webapp.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service" "admin_webapp" {
  name     = "admin-web-app"
  location = "us-central1"

  template {
    containers {
      image = "gcr.io/pr-db-fn-1/admin-webapp"
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "admin_public_invoker" {
  project  = var.bootcamp_project_id
  location = "us-central1"
  name     = "admin-web-app"

  role   = "roles/run.invoker"
  member = "allUsers"
}
