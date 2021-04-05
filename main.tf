terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "interview"
  region  = "us-east-1"
}

resource "aws_instance" "worker" {
  ami           = "ami-05479f9c3ec0e2ec9"
  # spot_price    = var.spot_price
  instance_type = var.instance_type
  count         = var.instance_count
  tags = {
    Name          = "${var.instance_name_prefix}_${count.index}"
    MyDescription = "this is my worker server ${count.index}"
  }
}
