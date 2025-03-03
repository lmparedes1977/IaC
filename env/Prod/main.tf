module "aws-prod" {
    source = "../../infra"
    instancia = "t2.micro"
    regiao_aws = "us-east-1"
    chave = "Iac-PROD"
    ambiente = "prod"
    grupoDeSegurancaInstancia = "Prod_Instancia"
    producao = true 
    nomeGrupo = "Prod"
    maximo = 10
    minimo = 1
}

# output "IP" {
#     value = module.aws-prod.IP_publico
# }