variable "project_id" {
  description = "bootcamp project ID"
}

variable "region" {
  description = "Region for resources"
  
}


variable "bootcamp_project_id" {
  description = "bootcamp project ID"
}




variable "frontend_source_bucket" {
  description = "GCS bucket for frontend source files"
}
variable "product_api_image" {
  description = "Docker image for the product API"
}
variable "invoker_service_account_email" {
  description = "Service account email for Cloud Run invoker"
  default     = ""
  
}
variable "order_api_image" {
  description = "The container image for the order API Cloud Run service"
  type        = string
}

variable "admin_source_bucket" {
  description = "GCS bucket for admin portal source files"
}

variable "pubsub_writer_service_account" {
  description = "Service account email for Pub/Sub to BigQuery writer"
  type        = string
}

variable "pubsub_admin_service_account" {
  description = "Service account email for Pub/Sub BigQuery admin"
  type        = string
}