terraform {
  required_version = ">= 1.3"
  cloud {
    organization = "lhtran"

    workspaces {
      name = "oci-instance-gatewise"
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.96.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.3"
    }
  }
}