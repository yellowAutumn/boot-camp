
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