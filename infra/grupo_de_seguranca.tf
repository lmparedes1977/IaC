resource "aws_security_group" "acesso" {
    name = "acesso_${var.ambiente}_alura"
    description = "grupo Seguranca equipe Desenvolvimento"
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        from_port = 0
        to_port = 0
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