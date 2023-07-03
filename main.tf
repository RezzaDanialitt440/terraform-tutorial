terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


locals {
  environment_name = terraform.workspace
  project_name  = "Terraform Tutorial"
  owner         = "rezza danial"
  vpc_id        = "vpc-07d792aee5ef310ef"
  subnet_id     = "subnet-0d2819ae136b14e88"
  ssh_user      = "ec2-user"
  key_name      = "tutorial"
  private_key_path  = "/home/ec2-user/environment/terraform-tutorial/tutorial.pem"
}

resource "aws_instance" "nginx" {
  ami           = var.ami
  subnet_id     = local.subnet_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  security_groups = [aws_security_group.nginx.id]
  key_name      = local.key_name
  
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
    
    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.nginx.public_ip
    }
  }
  
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
  }

  tags = {
    Name      = var.instance_name
    Owner     = local.owner
    Project   = local.project_name
    Environment = local.environment_name
  }
}

resource "aws_security_group" "nginx" {
  name        = "${local.environment_name}-nginx_access"

  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
