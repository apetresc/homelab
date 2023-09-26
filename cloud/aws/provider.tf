terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.1"
    }
  }
  backend "s3" {
    bucket = "apetresc-terraform-state"
    key    = "homelab/terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

