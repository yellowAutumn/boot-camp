resource "google_storage_bucket" "data_lake" {
  name     = "${var.project_id}-data-lake"
  location = var.region

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365 # Retain data for 1 year
    }
  }
}

resource "google_bigquery_dataset" "analytics" {
  dataset_id = "ecommerce_analytics"
  project    = var.project_id
  location   = "us-central1"
}

resource "google_bigquery_table" "event_logs" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = "event_logs"
  project    = var.project_id
  deletion_protection = false
  schema = <<EOF
[
  {"name": "event_id", "type": "STRING", "mode": "REQUIRED"},
  {"name": "event_type", "type": "STRING", "mode": "REQUIRED"},
  {"name": "user_id", "type": "STRING", "mode": "NULLABLE"},
  {"name": "event_timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"},
  {"name": "event_data", "type": "STRING", "mode": "NULLABLE"}
]
EOF

  time_partitioning {
    type = "DAY"
  }
}

resource "google_pubsub_topic" "product_events" {
  name = "product-events"
  message_storage_policy {
    allowed_persistence_regions = ["us-central1"]
  }
}

resource "google_pubsub_subscription" "product_events_bq" {
  name  = "product_events_bq"
  topic = google_pubsub_topic.product_events.name

  bigquery_config {
    table            = "${var.project_id}.${google_bigquery_dataset.analytics.dataset_id}.event_logs"
    use_topic_schema = false
  }
}

resource "google_bigquery_table_iam_binding" "bigquery_data_editor" {
  project     = var.project_id
  dataset_id  = google_bigquery_dataset.analytics.dataset_id
  table_id    = google_bigquery_table.event_logs.table_id
  role        = "roles/bigquery.dataEditor"
  members     = [
    "serviceAccount:${var.invoker_service_account_email}"
  ]  # Using your service account from variables
}

resource "google_bigquery_table_iam_binding" "pubsub_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = google_bigquery_table.event_logs.table_id
  role       = "roles/bigquery.dataEditor"
  members    = [
    "serviceAccount:${var.pubsub_writer_service_account}"
  ]
}

resource "google_bigquery_job" "create_event_logs_linear_model" {
  job_id   = "create-event-logs-linear-model-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  project  = var.project_id
  location = "us-central1"

  query {
    query = <<EOF
      CREATE OR REPLACE MODEL `${var.project_id}.${google_bigquery_dataset.analytics.dataset_id}.event_logs_linear_model`
      OPTIONS(model_type='linear_reg') AS
      SELECT
        CAST(JSON_VALUE(event_data, '$.products_count') AS FLOAT64) AS feature,
        EXTRACT(HOUR FROM event_timestamp) AS hour_feature,
        1.0 AS label  -- Replace with a real label if available
      FROM
        `${var.project_id}.${google_bigquery_dataset.analytics.dataset_id}.event_logs`
      WHERE
        SAFE_CAST(JSON_VALUE(event_data, '$.products_count') AS FLOAT64) IS NOT NULL
        AND event_timestamp IS NOT NULL
    EOF
    use_legacy_sql = false
  }
}

resource "google_bigquery_dataset_iam_member" "bigquery_admin" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  role       = "roles/bigquery.admin"
  member     = "serviceAccount:${var.invoker_service_account_email}"
}

resource "google_bigquery_dataset_iam_member" "bigquery_admin_pubsub" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  role       = "roles/bigquery.admin"
  member     = "serviceAccount:${var.pubsub_admin_service_account}"
}
