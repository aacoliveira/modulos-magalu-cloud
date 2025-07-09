terraform {
  required_providers {
    mgc = {
      source  = "magalucloud/mgc"
      version = "0.33.0"
    }
  }
}

provider "mgc" {
  region  = var.mgc_region
  api_key = var.api_key
}