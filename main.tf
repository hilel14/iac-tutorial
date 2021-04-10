terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = [aws_vpc.main.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
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

# Internet gateway
resource "aws_internet_gateway" "tutorials_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "tutorials-gw"
  }
}

# Route tables
resource "aws_route_table" "tutorials_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tutorials_gw.id
  }
  tags = {
    Name = "tutorials-route-table"
  }
}
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.tutorials_route_table.id
}

# Prepare resources to be provisioned with Cloud-Init

data "template_file" "user_data" {
  template = file("add-python-script.yaml")
}

# Worker instances
resource "aws_instance" "worker" {
  vpc_security_group_ids      = [aws_security_group.interview_security_group.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main.id
  ami                         = "ami-03eaf3b9c3367e75c"
  key_name                    = "tutorials"
  # spot_price    = var.spot_price
  instance_type = var.instance_type
  user_data                   = data.template_file.user_data.rendered
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
