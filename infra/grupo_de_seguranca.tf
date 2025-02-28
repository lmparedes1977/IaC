resource "aws_security_group" "instancia" {
    name = var.grupoDeSegurancaInstancia
    description = "Permitir acesso HTTP do Load Balancer"
    vpc_id      = aws_default_vpc.default.id

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "-1"
        security_groups = [ aws_security_group.loadBalancer ]
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "acesso_${var.ambiente}"
    }
}

resource "aws_security_group" "loadBalancer" {
    name = var.grupoDeSegurancaLb
    description = "Permitir acesso do Load Balancer"
    vpc_id      = aws_default_vpc.default.id
    
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        from_port = 8000
        to_port = 8000
        protocol = "-1"
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "acesso_${var.ambiente}"
    }
}