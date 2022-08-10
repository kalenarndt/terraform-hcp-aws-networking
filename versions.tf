terraform {
  required_version = ">=1.2.7, <=1.2.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.15"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">=0.10.0"
    }
  }
}
