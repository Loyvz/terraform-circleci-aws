provider "aws" {
  region = "us-east-1"
}

# Crear VPC
resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "mi-vpc"
  }
}

# Crear Subnet Pública
resource "aws_subnet" "mi_subnet" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "mi-subnet"
  }
}

# Crear Internet Gateway 🚀 (Esto faltaba)
resource "aws_internet_gateway" "mi_igw" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "mi-gateway"
  }
}

# Crear Route Table para permitir salida a Internet
resource "aws_route_table" "mi_route_table" {
  vpc_id = aws_vpc.mi_vpc.id

  # 🚀 Regla para permitir tráfico de salida a Internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_igw.id
  }

  tags = {
    Name = "mi-route-table"
  }
}

# Asociar la Route Table con la Subnet 🚀
resource "aws_route_table_association" "mi_rta" {
  subnet_id      = aws_subnet.mi_subnet.id
  route_table_id = aws_route_table.mi_route_table.id
}

# Crear Security Group con acceso a Internet 🚀
resource "aws_security_group" "mi_sg" {
  vpc_id = aws_vpc.mi_vpc.id
  name   = "mi_sg"

  # Permitir SSH desde cualquier parte
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir tráfico HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir todo el tráfico de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mi-sg"
  }
}

# Crear Instancia EC2 con Docker 🚀
resource "aws_instance" "mi_ec2" {
  ami                         = "ami-01e076d5c9e040974"  # Ubuntu 22.04 en us-east-1
  instance_type               = "t2.micro"
  key_name                    = var.aws_key_name
  subnet_id                   = aws_subnet.mi_subnet.id
  vpc_security_group_ids       = [aws_security_group.mi_sg.id]
  associate_public_ip_address  = true
  user_data                   = file("install-docker.sh")

  tags = {
    Name = "Servidor-Docker"
  }
}
