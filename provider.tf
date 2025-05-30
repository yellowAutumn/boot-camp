terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # This means any version 5.x.x but not 6.x.x
      # You could also use ">= 5.0.0" for latest 5.x.x or a specific "5.10.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}