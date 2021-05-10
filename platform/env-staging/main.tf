variable environment {
  default = "staging"
}

#--------------------------------------------------------------
# GCP Provider
#--------------------------------------------------------------
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.57.0"
    }

    random = {
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project     = "client-dev-caradvice"
  region      = "australia-southeast1"
  credentials = file("mrkloud-gcp-763f9787b8b2.json")

}

#--------------------------------------------------------------
# Backend - app.terraform.io
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.13"
  backend "remote" {
    workspaces {
      name = "staging"
    }
  }
}

#--------------------------------------------------------------
# Modules
#--------------------------------------------------------------

module "bigquery" {
  source = "./bigquery"
  dataset_id = "${var.environment}_${var.client_app_name}"
  environment = var.environment
  vendor = var.vendor
}

module "iam" {
  source = "./iam"
}

module "storage" {
  source = "./storage"
  vendor = var.vendor
  environment = var.environment
  region-code = var.region_code
  client-app-name = var.client_app_name
}

module "cloud-functions" {
  source = "./cloud-functions"
  bucket-name = module.storage.cloud-function-bucket.name
  depends_on = [module.storage.cloud-function-bucket]
}
