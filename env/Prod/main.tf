module "aws-prod" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-2"
    chave = "Iac-PROD"
    ambiente = "prod"
}

output "IP" {
    value = module.aws-prod.IP_publico
}