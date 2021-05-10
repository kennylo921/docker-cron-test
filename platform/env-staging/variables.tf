#--------------------------------------------------------------
# Metadata
#--------------------------------------------------------------

variable "region" {
  default = "australia-southeast1"
}

variable "region_code" {
  default = "AUSTRALIA-SOUTHEAST1"
}

variable "vendor" {
  default = "lens10"
}

variable "client_name" {
  default = "drive"
}

variable "client_app_name" {
  default = "drive_flywheel"
}

#--------------------------------------------------------------
# Storage Bucket
#--------------------------------------------------------------

variable bucket_name_unprefixed {
  default = "downloads"
}

