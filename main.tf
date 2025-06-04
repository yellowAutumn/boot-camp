module "cloud_run" {
  source                 = "./modules/app_engine"
  frontend_source_bucket = var.frontend_source_bucket
  bootcamp_project_id    = var.bootcamp_project_id
}