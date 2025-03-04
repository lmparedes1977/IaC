terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region = var.regiao_aws
}

# resource "aws_instance" "app_server" {  # recurso utilizado para criar máquinas no EC2 do aws
#   ami = "ami-0cb91c7de36eed2cb"
#   instance_type = var.instancia
#   key_name = var.chave
#   tags = {
#     Name = "Instancia com python e virtualenv"
#   }
# }

resource "aws_launch_template" "maquina" {
  name = "maquina-template"
  image_id = "ami-04b4f1a9cf54c11d0"
  instance_type = var.instancia
  key_name = var.chave
  tags = {
    Name = "Terraform Ansible Python"
  }
  vpc_security_group_ids = [ aws_security_group.acesso_geral.id ]
  user_data = var.producao ? filebase64("ansible.sh") : ""
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.chave
  public_key = file("${var.chave}.pub")
}

resource "aws_autoscaling_group" "grupo" {
  availability_zones = [ "${var.regiao_aws}a", "${var.regiao_aws}b" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  target_group_arns = [ aws_lb_target_group.alvoLoadBalancer.arn ]
  launch_template {
    id = aws_launch_template.maquina.id
    version = "$Latest"
  }
}

resource "aws_default_subnet" "subnet1" {
  availability_zone = "${var.regiao_aws}a"  
}

resource "aws_default_subnet" "subnet2" {
  availability_zone = "${var.regiao_aws}b"  
}

resource "aws_lb" "loadBlancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet1.id, aws_default_subnet.subnet2.id ]
}

resource "aws_default_vpc" "default" {  
}

resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "maquinasAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "entrada_load_balancer" {
  load_balancer_arn = aws_lb.loadBlancer.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer.arn
  }
}

resource "aws_autoscaling_policy" "escalaProducao" {
  name = "terraform-escala"
  autoscaling_group_name = var.nomeGrupo
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}



# output "IP_publico" {
#   value = aws_instance.app_server.public_ip
# }