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
  project     = "client-dev-ca"
  region      = "australia-southeast1"
}

#--------------------------------------------------------------
# Backend - app.terraform.io
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.13"
  backend "remote" {
    organization = ""
    workspaces {
      name = "staging"
    }
  }
}

#--------------------------------------------------------------
# Modules
#--------------------------------------------------------------
module "gce-container" {
  source = "github.com/terraform-google-modules/terraform-google-container-vm"
  cos_image_name = "cos-stable-89-16108-403-26"
  container = {
    image = "gcr.io/client-dev-ca/sample-image:tagged.15"

    env = [
      {
        name = "TEST_VAR"
        value = "Hello World!"
      },
    ]
  }

  restart_policy = "Always"
}


resource "google_service_account" "default" {
  account_id   = "compute-engine-service-account"
  display_name = "CarAdvice Compute Engine Service Account"
}

resource "google_compute_instance" "vm" {
  project      = "client-dev-ca"
  name         = "test-instance"
  machine_type = "e2-micro"
  zone         = "australia-southeast1-a"

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  tags = ["container-vm-example"]

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

   network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
  allow_stopping_for_update = true
  depends_on = [google_service_account.default]
}
