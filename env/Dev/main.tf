module "aws-dev" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-2"
    chave = "Iac-DEV"
    ambiente = "dev"
    grupoDeSeguranca = "Desenvolvimento"
    nomeGrupo = "Dev"
    maximo = 1
    minimo = 0
}

# output "IP" {
#     value = module.aws-dev.IP_publico
# }