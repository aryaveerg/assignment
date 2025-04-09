# assignment
 
# Flask API Deployment with Docker, GitHub Actions, and Terraform

This project demonstrates how to deploy a simple Flask API using Docker, GitHub Actions for CI/CD, and Terraform for infrastructure provisioning on AWS.

---

## 📦 Project Structure

assignment/ ├── app.py ├── Dockerfile ├── requirements.txt ├── terraform/ │ ├── main.tf │ └── variables.tf └── .github/ └── workflows/ └── deploy.yml


---

## 🚀 Setup Instructions

1. **Install Required Tools**
   - Docker Desktop
   - GitHub Desktop
   - Terraform
   - AWS CLI (optional for manual testing)

2. **Docker Image**
   - Build your image:
     ```bash
     docker build -t yourdockerhub/flask-api .
     docker push yourdockerhub/flask-api
     ```

3. **Provision VM using Terraform**
   - Navigate to `terraform/` directory:
     ```bash
     terraform init
     terraform apply
     ```
   - It will:
     - Launch an EC2 instance
     - Open ports 22 (SSH) and 5000 (Flask)
     - Run your Docker container on boot

4. **Set GitHub Secrets**
   - `dockerhub_username`: your DockerHub username  
   - `dockerhub_token`: personal access token from DockerHub  
   - `vm_host`: your EC2 public IP (after Terraform deploys it)  
   - `vm_user`: usually `ubuntu` for Ubuntu AMIs  
   - `vm_ssh_key`: your private key (`.pem` or generated one)

5. **Trigger Deployment**
   - Push changes to `main` branch.
   - GitHub Actions will:
     - Build + push Docker image
     - SSH into VM
     - Pull + run container

---

## ✅ End Result

Your Flask API should be live at:
