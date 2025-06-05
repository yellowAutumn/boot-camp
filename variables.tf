
variable "project_id" {
  description = "bootcamp project ID"
}

variable "region" {
  description = "Region for resources"
  default     = "us-central1"
}


variable "bootcamp_project_id" {
  description = "bootcamp project ID"
}



variable "region" {
  description = "region for resources"
  default= "us-central1"
}

variable "frontend_source_bucket" {
  description = "GCS bucket for frontend source files"
}
variable "product_api_image" {
  description = "Docker image for the product API"
  default     = "gcr.io/my-project/product-api:latest" # Update with your image
}
variable "invoker_service_account_email" {
  description = "Service account email for Cloud Run invoker"
  default     = ""
  
}
variable "order_api_image" {
  description = "The container image for the order API Cloud Run service"
  type        = string
}
