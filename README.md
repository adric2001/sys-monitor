# Containerized System Resource Monitor

## Project Overview
This project is a lightweight, cloud-native API designed to monitor real-time system health metrics (CPU, Memory, Disk). It demonstrates the modernization of legacy system administration tasks by wrapping system-level monitoring tools into a portable, containerized microservice.

## Tech Stack
* **Language:** Python 3.9 (Flask Framework)
* **Infrastructure:** Docker
* **System Tools:** psutil library for cross-platform hardware monitoring

## How It Works
1.  The application queries the underlying Linux kernel for resource usage.
2.  It exposes these metrics via a RESTful JSON endpoint.
3.  The environment is fully containerized, ensuring it runs consistently across Development, Staging, and Production environments.

## Quick Start (Run Locally)

### 1. Build the Image
```bash
docker build -t sys-monitor .