terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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

