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

# VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name          = "interview_main_vpc"
    MyDescription = "this is my interview main vpc "
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name          = "interview_main_subnet"
    MyDescription = "this is my interview main subnet "
  }
}

# Security group
resource "aws_security_group" "interview_security_group" {
  name        = "interview_security_group"
  description = "A secutiry group for the interview project"
  vpc_id      = aws_vpc.main.id
  # Allow SSH inbound
  ingress {
    description = "SSH from anyware"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  # allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # tags
  tags = {
    Name          = "interview_security_group"
    MyDescription = "this is my interview firewall rules "
  }
}

# Worker instances
resource "aws_instance" "worker" {
  #vpc_security_group_ids = [aws_vpc.main.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main.id
  ami                         = "ami-03eaf3b9c3367e75c"
  # spot_price    = var.spot_price
  instance_type = var.instance_type
  count         = var.instance_count
  tags = {
    Name          = "${var.instance_name_prefix}_${count.index}"
    MyDescription = "this is my worker server ${count.index}"
  }
}

# Incoming queue
resource "aws_sqs_queue" "in_queue" {
  name       = "interview-incoming-queue.fifo"
  fifo_queue = true
}

# Outgoing queue
resource "aws_sqs_queue" "out_queue" {
  name       = "interview-outgoing-queue.fifo"
  fifo_queue = true
}
