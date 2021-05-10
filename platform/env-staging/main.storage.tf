locals {
  bucket_name = "${var.environment}-${var.client_app_name}-${var.bucket_name_unprefixed}"
  base_labels = {
    vendor = var.vendor
    environment = var.environment
    stack = "storage"
    deployer = "terraform"
  }
}

resource "google_storage_bucket" "csv-bucket" {
  name          = local.bucket_name
  location      = var.region_code
  force_destroy = var.environment == "staging"
  labels = merge({name=local.bucket_name}, local.base_labels)
}


#gcr.io/client-dev-caradvice/test
