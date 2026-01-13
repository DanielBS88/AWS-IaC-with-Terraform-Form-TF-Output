Step-by-Step: AWS IaC com Terraform
1. Pré-requisitos
Conta AWS com usuário IAM e chaves de acesso válidas.
AWS CLI instalada e configurada.
Terraform instalado (>= 1.5.7).
Git instalado.
2. Configuração das Credenciais AWS
a) Via arquivo
Crie ou edite o arquivo ~/.aws/credentials:

bash


mkdir -p ~/.aws
cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = SUA_ACCESS_KEY
aws_secret_access_key = SUA_SECRET_KEY
EOF
b) Teste as credenciais
bash


aws sts get-caller-identity
Se retornar informações da conta, está correto.

3. Estrutura dos Arquivos Terraform
Crie os arquivos necessários:

bash


touch main.tf versions.tf variables.tf vpc.tf outputs.tf terraform.tfvars .gitignore
4. Conteúdo dos Arquivos
a) .gitignore
bash


cat > .gitignore <<EOF
*.tfstate
*.tfstate.*
.terraform/
crash.log
*.tfvars
*.backup
.terraform.lock.hcl
EOF
b) versions.tf
bash


cat > versions.tf <<EOF
terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
EOF
c) main.tf
bash


cat > main.tf <<EOF
provider "aws" {
  region = var.aws_region
}
EOF
d) variables.tf
bash


cat > variables.tf <<EOF
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(object({
    name = string
    cidr = string
    az   = string
  }))
  default = [
    { name = "cmtr-k5vl9gpq-01-subnet-public-a", cidr = "10.10.1.0/24", az = "us-east-1a" },
    { name = "cmtr-k5vl9gpq-01-subnet-public-b", cidr = "10.10.3.0/24", az = "us-east-1b" },
    { name = "cmtr-k5vl9gpq-01-subnet-public-c", cidr = "10.10.5.0/24", az = "us-east-1c" }
  ]
}
EOF
e) terraform.tfvars
bash


cat > terraform.tfvars <<EOF
aws_region = "us-east-1"
vpc_cidr   = "10.10.0.0/16"
EOF
f) vpc.tf
bash


cat > vpc.tf <<EOF
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "cmtr-k5vl9gpq-01-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index].cidr
  availability_zone = var.public_subnets[count.index].az
  tags = {
    Name = var.public_subnets[count.index].name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "cmtr-k5vl9gpq-01-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "cmtr-k5vl9gpq-01-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
EOF
g) outputs.tf
bash


cat > outputs.tf <<EOF
output "vpc_id" {
  description = "The unique identifier of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block associated with the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "A set of IDs for all public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "public_subnet_cidr_block" {
  description = "A set of CIDR's block for all public subnets"
  value       = [for s in aws_subnet.public : s.cidr_block]
}

output "public_subnet_availability_zone" {
  description = "A set of AZ's for all public subnets"
  value       = [for s in aws_subnet.public : s.availability_zone]
}

output "internet_gateway_id" {
  description = "The unique identifier of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "routing_table_id" {
  description = "The unique identifier of the routing table"
  value       = aws_route_table.public.id
}
EOF
5. Inicialização e Deploy com Terraform
bash


terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform init: Inicializa o projeto.
terraform fmt: Formata os arquivos.
terraform validate: Valida a sintaxe.
terraform plan: Mostra o que será criado.
terraform apply: Cria os recursos.
6. Versionamento com Git
bash


git init
git add .
git commit -m "Infraestrutura AWS VPC com Terraform"
git remote add origin <URL_DO_SEU_REPOSITORIO>
git branch -M main
git push -u origin main
7. Validação
No terminal: Após o terraform apply, confira os outputs (vpc_id, subnets, etc).
No AWS Console: Verifique a criação da VPC, subnets, internet gateway e tabela de rotas.
8. Boas Práticas
Use .gitignore para evitar versionar arquivos sensíveis ou desnecessários.
Separe variáveis, recursos e outputs em arquivos distintos.
Sempre valide e formate o código antes de aplicar.
