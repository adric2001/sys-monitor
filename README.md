# ☁️ Cloud-Native System Monitor

![Project Status](https://img.shields.io/badge/status-active-success.svg)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=flat&logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat&logo=amazon-aws&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)

## 📖 Project Overview
This project is a full-stack DevOps demonstration that monitors real-time system resources (CPU, Memory, Disk). Unlike a traditional script, this application is **containerized**, **automatically built** via CI/CD, and **deployed** to AWS using Infrastructure as Code (IaC).

It bridges the gap between System Administration and modern Cloud Engineering by treating infrastructure as flexible software.

### Project hosted on AWS
Public EC2 Instance with Docker Container Hosting Project ---> 54.145.168.203:5000

## 🏗 Architecture
The project follows a modern "Immutable Infrastructure" approach:

1.  **Code:** Python Flask application queries kernel-level metrics.
2.  **Containerization:** Docker packages the app and dependencies into a portable image.
3.  **CI/CD:** GitHub Actions automatically builds the image and pushes it to the GitHub Container Registry (GHCR) on every commit.
4.  **Infrastructure:** Terraform provisions a free-tier AWS EC2 instance (t2.micro), configures Security Groups (Firewall), and bootstraps the server to pull and run the latest container on startup.

## 🛠 Tech Stack
* **Application:** Python 3.9, Flask, psutil
* **Containerization:** Docker, Multi-arch builds (AMD64/ARM64)
* **Infrastructure as Code:** Terraform
* **Cloud Provider:** AWS (EC2, VPC, IAM)
* **CI/CD:** GitHub Actions, GitHub Packages

## 🚀 How to Deploy

### Option 1: Run Locally (Docker)
You can run the production image on your local machine without installing Python.
```bash
# 1. Login to Registry
docker login ghcr.io -u YOUR_GITHUB_USER

# 2. Run the Container
docker run -p 5000:5000 ghcr.io/adric2001/sys-monitor:main