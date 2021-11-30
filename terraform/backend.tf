terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "playground"
}

provider "sops" {}
