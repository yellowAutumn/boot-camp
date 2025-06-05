resource "google_app_engine_application" "app" {
  project     = var.bootcamp_project_id
  location_id = var.region # e.g., "us-central" (App Engine uses region, not zone)

  # Optional: Set the serving status (default is "SERVING")
  # serving_status = "SERVING"
}

variable "admin_source_bucket" {
  description = "The name of the GCS bucket containing the admin portal source code zip"
  type        = string
}

resource "google_app_engine_standard_app_version" "frontend" {
  service      = "default"
  version_id   = "v1"
  runtime      = "python39" # Use a runtime suitable for your frontend (e.g., python39 for static files)
  entrypoint {
    shell = "gunicorn -b :$PORT main:app"
  }

  deployment {
    zip {
      source_url  = "gs://${var.frontend_source_bucket}/frontend.zip"
      files_count = 1
    }
  }

  automatic_scaling {
    standard_scheduler_settings {
      max_instances = 1
    }
  }
}

resource "google_app_engine_standard_app_version" "admin_portal" {
  service      = "admin"
  version_id   = "v1"
  runtime      = "python39" # Adjust runtime as needed for your admin portal
  entrypoint {
    shell = "gunicorn -b :$PORT main:app"
  }

  deployment {
    zip {
      source_url  = "gs://${var.admin_source_bucket}/admin.zip"
      files_count = 1
    }
  }

  automatic_scaling {
    standard_scheduler_settings {
      max_instances = 1
    }
  }
}