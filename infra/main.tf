terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region = var.regiao_aws
}

resource "aws_instance" "app_server" {
  ami = "ami-0cb91c7de36eed2cb"
  instance_type = var.instancia
  key_name = var.chave
  tags = {
    Name = "Instancia com python e virtualenv"
  }

}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.chave
  public_key = file("${var.chave}.pub")
}

output "IP_publico" {
  value = aws_instance.app_server.public_ip
}