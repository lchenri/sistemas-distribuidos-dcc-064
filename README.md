# Sistemas Distribuídos - Infraestrutura AWS

Este projeto provisiona uma infraestrutura AWS usando Terraform para hospedar uma aplicação Node.js que apresenta conceitos de sistemas distribuídos.

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Conta AWS com permissões adequadas para criar recursos EC2, VPC e Security Groups

## 🏗️ Arquitetura

A infraestrutura provisiona os seguintes recursos na AWS:

- **VPC** com subnets públicas
- **EC2 Instance** (t2.micro - Free Tier eligible)
- **Security Groups** com regras de acesso HTTP/HTTPS
- **Nginx** como proxy reverso
- **Aplicação Node.js** servindo conteúdo sobre sistemas distribuídos

## 🚀 Configuração do Terraform

### 1. Configurar Credenciais AWS

Certifique-se de que suas credenciais AWS estão configuradas:

```bash
aws configure
```

Ou configure as variáveis de ambiente:

```bash
export AWS_ACCESS_KEY_ID="sua_access_key"
export AWS_SECRET_ACCESS_KEY="sua_secret_key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 2. Clonar o Repositório

```bash
git clone <url-do-repositorio>
cd sistemas_distribuidos
```

### 3. Inicializar o Terraform

Navegue até o diretório `infra/` e inicialize o Terraform:

```bash
cd infra
terraform init
```

### 4. Validar Configuração

Verifique se a configuração está correta:

```bash
terraform validate
terraform plan
```

### 5. Aplicar a Infraestrutura

Provisione os recursos na AWS:

```bash
terraform apply
```

Digite `yes` quando solicitado para confirmar a criação dos recursos.

### 6. Acessar a Aplicação

Após a aplicação bem-sucedida, o Terraform exibirá o IP público da instância EC2. A aplicação estará disponível em:

```
http://<IP_PUBLICO_DA_INSTANCIA>
```

## 📁 Estrutura do Projeto

```
sistemas_distribuidos/
├── infra/
│   ├── main.tf              # Configuração principal do provider AWS
│   ├── vpc.tf               # Configuração da VPC e subnets
│   ├── security_group.tf    # Regras de segurança
│   └── ec2.tf               # Instância EC2 e configuração da aplicação
└── README.md
```

## 🔧 Personalização

### Alterar Região AWS

Para alterar a região, modifique o arquivo `infra/main.tf`:

```hcl
provider "aws" {
  region = "us-west-2"  # Altere para sua região preferida
}
```

### Modificar Tipo de Instância

Para usar um tipo de instância diferente, altere no arquivo `infra/ec2.tf`:

```hcl
resource "aws_instance" "ec2_instance" {
  instance_type = "t3.micro"  # Altere conforme necessário
  # ... outras configurações
}
```

## 🧹 Limpeza dos Recursos

Para evitar custos desnecessários, destrua a infraestrutura quando não precisar mais:

```bash
terraform destroy
```

Digite `yes` para confirmar a destruição dos recursos.

## 📊 Recursos Criados

Este projeto cria os seguintes recursos AWS:

- 1x VPC
- 2x Subnets públicas
- 1x Internet Gateway
- 1x Route Table
- 1x Security Group
- 1x EC2 Instance (t2.micro)

**Estimativa de custos**: A maioria dos recursos está dentro do Free Tier da AWS para novos usuários.

## 🔒 Considerações de Segurança

- A instância EC2 aceita conexões HTTP na porta 80 de qualquer origem
- Para ambientes de produção, considere:
  - Usar HTTPS com certificados SSL/TLS
  - Restringir acesso por IP
  - Implementar autenticação
  - Usar subnets privadas com NAT Gateway

## 📚 Sobre a Aplicação

A aplicação Node.js hospedada apresenta conceitos fundamentais de sistemas distribuídos, incluindo:

- Concorrência
- Escalabilidade  
- Tolerância a falhas
- Transparência

## 🤝 Contribuição

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
