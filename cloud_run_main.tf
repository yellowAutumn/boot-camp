resource "google_cloud_run_service" "product_api" {
  name     = "product-api"
  location = var.region
  project  = var.bootcamp_project_id

  template {
    spec {
      containers {
        image = var.product_api_image # e.g., "gcr.io/my-project/product-api:latest"
        ports {
          container_port = 8080
        }
        env {
          name  = "ENV"
          value = "production"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.product_api.name
  location = google_cloud_run_service.product_api.location
  project  = google_cloud_run_service.product_api.project
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.invoker_service_account_email}" # Use a specific service account for restricted access
}

resource "google_cloud_run_service" "order_api" {
  name     = "order-api"
  location = var.region
  project  = var.bootcamp_project_id

  template {
    spec {
      containers {
        image = var.order_api_image # e.g., "gcr.io/my-project/order-api:latest"
        ports {
          container_port = 8080
        }
        env {
          name  = "ENV"
          value = "production"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "order_invoker" {
  service  = google_cloud_run_service.order_api.name
  location = google_cloud_run_service.order_api.location
  project  = google_cloud_run_service.order_api.project
  role     = "roles/run.invoker"
  member   = "serviceAccount:${var.invoker_service_account_email}" # Use the same service account for both services
}


