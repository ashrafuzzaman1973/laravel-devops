# 🚀 Laravel 12 CI/CD using AWS (EC2, RDS, S3, CodeDeploy) & Bitbucket Pipelines

### ✍️ Author: Ashrafuzzaman  
📧 Email: ashrafdiu1973@gmail.com  

---

## 🔥 Overview

This repository demonstrates a **complete CI/CD pipeline for Laravel 12** using AWS services and Bitbucket Pipelines.

It automates the full deployment lifecycle:

> **Code Push → Build → Test → Package → Deploy → Live 🚀**

---

## ⚙️ Tech Stack

- 🖥️ **AWS EC2** – Application server (Production/Staging)
- 🗄️ **AWS RDS (MySQL 8)** – Managed database
- 📦 **AWS S3** – Artifact storage (deployment bundles)
- 🚀 **AWS CodeDeploy** – Deployment automation
- 🔐 **AWS Systems Manager (SSM)** – Secure `.env` management
- 🔁 **Bitbucket Pipelines** – Continuous Integration & Deployment
- 🧠 **Bash Scripts** – Custom automation scripts

---

## 🧭 CI/CD Workflow

```text
Developer Push 
   ↓
Bitbucket Pipeline Triggered
   ↓
Build & Test Laravel App
   ↓
Create Deployment Bundle (.tar.gz)
   ↓
Upload Bundle to AWS S3
   ↓
Trigger AWS CodeDeploy
   ↓
Deploy to EC2 Instance
   ↓
Laravel Application Live 🚀
````

---

## 🔐 Required Repository Variables

Configure in:
**Bitbucket → Repository Settings → Pipelines → Repository Variables**

```env
AWS_ACCESS_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=ap-south-1
S3_BUCKET=your-s3-bucket-name
DEPLOYMENT_GROUP_NAME=your-codedeploy-group
```

---

## 📁 DevOps Directory Structure

```bash
devops/
│
├── build-server.sh              # Setup pipeline environment
├── build-project.sh             # Prepare Laravel for testing
├── build-for-production.sh      # Optimize for production
├── run-tests.sh                 # Run automated tests
├── deploy-production.sh         # Deploy to AWS (S3 + CodeDeploy)
│
├── hooks/
│   └── after-install.sh         # Runs on EC2 after deployment
│
└── scripts/
    ├── generate-env.sh          # Generate .env from AWS SSM
    ├── build-production-server.sh # (Manual) Setup EC2 server
    └── configure-apache.sh      # (Optional) Apache config
```

---

## 📄 Key Configuration Files

### `bitbucket-pipelines.yml`

* Defines CI/CD pipeline steps
* Runs build, test, and deployment scripts

### `appspec.yml`

* Used by AWS CodeDeploy
* Defines deployment lifecycle hooks

### `bundle.conf`

* Lists files included in deployment package

### `.env.pipelines`

* Used during pipeline build
* Loads environment variables from AWS SSM

---

## 🖥️ EC2 Deployment Hook Example

```bash
#!/bin/bash

cd /var/www/laravel

sudo chown -R ubuntu:ubuntu .
chmod -R 775 storage bootstrap/cache

composer install --no-dev --optimize-autoloader

php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

---

## ▶️ How to Use

### 1. Clone Repository

```bash
git clone https://github.com/ashrafuzzaman1973/laravel-devops.git
cd test-laravel-app
```

---

### 2. Configure AWS

* Create EC2 instance
* Setup RDS (MySQL)
* Create S3 bucket
* Setup CodeDeploy application & deployment group

---

### 3. Add Bitbucket Variables

Add all required environment variables (see above)

---

### 4. Push Code

```bash
git add .
git commit -m "Initial setup"
git push origin main
```

---

### 5. Trigger Deployment

* Pipeline runs automatically
* Production deploy is **manual trigger**

---

## 🧪 Logs & Debugging

Check CodeDeploy logs on EC2:

```bash
/var/log/aws/codedeploy-agent/codedeploy-agent.log
```

---

## ⚠️ Common Issues

### ❌ DeploymentConfigDoesNotExistException

Use:

```text
CodeDeployDefault.AllAtOnce
```

---

### ❌ Permission Issues

```bash
chmod -R 775 storage bootstrap/cache
```

---

### ❌ Missing .env File

👉 Use AWS Systems Manager Parameter Store

---

## 🎯 Features

✅ Fully automated Laravel deployment
✅ Zero manual file upload
✅ Secure environment management
✅ Scalable AWS infrastructure
✅ Production-ready CI/CD pipeline

---

## 🚀 Future Improvements

* Add staging environment
* Implement zero-downtime deployment
* Use Docker for containerization
* Add monitoring (CloudWatch / Laravel Horizon)

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

---

## 📄 License

This project is open-source and available under the MIT License.

---

## 👋 Author

**Ashrafuzzaman**
Full Stack Developer (Laravel | Vue | Nuxt | React)

