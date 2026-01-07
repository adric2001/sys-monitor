terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  # It will look for credentials in your environment variables or ~/.aws/credentials
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("my-key.pub")
}

# 1. Create a Security Group (Firewall)
resource "aws_security_group" "app_sg" {
  name        = "sys-monitor-sg"
  description = "Allow HTTP on 80 and SSH"

  ingress {
    from_port   = 80      # CHANGED: Standard Web Port
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # ... keep SSH ingress and the egress block the same ...
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Launch the Server (EC2)
resource "aws_instance" "app_server" {
  # ... keep ami, instance_type, key_name, security_groups ...
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              # 1. Install Docker & Compose
              curl -fsSL https://get.docker.com -o get-docker.sh
              sh get-docker.sh

              # 2. Create the Project Directory
              mkdir /app
              cd /app

              # 3. Write Nginx Config
              cat <<EOT > nginx.conf
              events {}
              http {
                  server {
                      listen 80;
                      location / {
                          proxy_pass http://app:5000;
                          proxy_set_header Host \$host;
                          proxy_set_header X-Real-IP \$remote_addr;
                      }
                  }
              }
              EOT

              # 4. Write Docker Compose File
              # WE USE 'EOT' to write the file content to disk on the server
              cat <<EOT > docker-compose.yml
              version: '3'
              services:
                app:
                  image: ghcr.io/adric2001/sys-monitor:main
                  restart: always
                  expose:
                    - "5000"
                nginx:
                  image: nginx:latest
                  restart: always
                  ports:
                    - "80:80"
                  volumes:
                    - ./nginx.conf:/etc/nginx/nginx.conf:ro
                  depends_on:
                    - app
              EOT

              # 5. Start the Stack
              docker compose up -d
              EOF
  
  tags = {
    Name = "SysMonitor-Production"
  }
}

# 3. Output the Public IP
output "server_ip" {
  value = "http://${aws_instance.app_server.public_ip}"
}