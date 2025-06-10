resource "google_cloud_run_service" "product_api" {
  name     = "product-api"
  location = var.region
  project  = var.bootcamp_project_id

  template {
    spec {
      containers {
        image = var.product_api_image # e.g., "gcr.io/my-project/product-api:latest"
        ports {
          container_port = 5000
        }
        env {
          name  = "ENV"
          value = "production"
        }

        env {
          name  = "PUBSUB_TOPIC"
          value = "projects/${var.bootcamp_project_id}/topics/product-events"
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
          container_port = 5000
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

resource "google_cloud_run_service_iam_member" "product_api_public" {
  service  = google_cloud_run_service.product_api.name
  location = google_cloud_run_service.product_api.location
  project  = google_cloud_run_service.product_api.project
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "order_api_public" {
  service  = google_cloud_run_service.order_api.name
  location = google_cloud_run_service.order_api.location
  project  = google_cloud_run_service.order_api.project
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "product_api_url" {
  value = google_cloud_run_service.product_api.status[0].url
}

output "order_api_url" {
  value = google_cloud_run_service.order_api.status[0].url
}

resource "local_file" "frontend_config" {
  filename = "${path.module}/public/config.json"
  content = jsonencode({
    productApiUrl = google_cloud_run_service.product_api.status[0].url
    orderApiUrl   = google_cloud_run_service.order_api.status[0].url
  })
}

# resource "google_pubsub_topic" "product_events" {
#   name = "product-events"
# }

# resource "google_pubsub_topic_iam_member" "publisher" {
#   topic  = google_pubsub_topic.product_events.name
#   role   = "roles/pubsub.publisher"
#   member = "serviceAccount:${var.cloud_run_service_account_email}"
# }


# resource "google_bigquery_table_iam_binding" "bigquery_data_editor" {
#   project     = var.project_id
#   dataset_id  = google_bigquery_dataset.dataset.dataset_id
#   table_id    = google_bigquery_table.table.table_id
#   role        = "roles/bigquery.dataEditor"
#   members     = ["serviceAccount:${var.invoker_service_account_email}"]
# }

