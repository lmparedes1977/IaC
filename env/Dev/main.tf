module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-2"
    chave = "Iac-DEV"
    ambiente = "dev"
}

output "IP" {
    value = module.aws-dev.IP_publico
}