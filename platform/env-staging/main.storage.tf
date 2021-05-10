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

resource "google_storage_bucket_object" "flightschedule_nine" {
  name          = "flightschedule_nine/"
  content       = "Channel 9 Folder"
  bucket        = "${google_storage_bucket.csv-bucket.name}"
}

resource "google_storage_bucket_object" "flightschedule_agency_csv" {
  name          = "flightschedule_agency_csv/"
  content       = "Manual Agency CSV Folder"
  bucket        = "${google_storage_bucket.csv-bucket.name}"
}


#gcr.io/client-dev-caradvice/test

