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

# 1. Create a Security Group (Firewall)
resource "aws_security_group" "app_sg" {
  name        = "sys-monitor-sg"
  description = "Allow HTTP on 5000 and SSH"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world (for demo purposes)
  }

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
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (us-east-1)
  instance_type = "t2.micro"              # Free tier eligible
  security_groups = [aws_security_group.app_sg.name]

  # This script runs once when the server boots
  user_data = <<-EOF
              #!/bin/bash
              # Update and install Docker
              apt-get update
              apt-get install -y docker.io
              
              # Pull and run your image from GitHub Container Registry
              docker run -d -p 5000:5000 ghcr.io/adric2001/sys-monitor:main
              EOF

  tags = {
    Name = "SysMonitor-Production"
  }
}

# 3. Output the Public IP
output "server_ip" {
  value = "http://${aws_instance.app_server.public_ip}:5000"
}