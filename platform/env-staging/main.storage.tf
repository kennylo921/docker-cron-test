locals {
  bucket_name = "${var.environment}-${var.client_app_name}-${var.bucket_name_unprefixed}"
  base_labels = {
    vendor = var.vendor
    environment = var.environment
    stack = "storage"
    deployer = "terraform"
  }
}


#gcr.io/client-dev-caradvice/test
