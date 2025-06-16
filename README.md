# 🚀 Automate Docker Image Creation & Deployment using Jenkins Pipeline

This project demonstrates how to automate the CI/CD process of building a Docker image, pushing it to a self-hosted Docker registry, and running it as a container — all triggered through a Jenkins pipeline.


---

## 🧰 Tech Stack
- Jenkins (Pipeline + Docker Plugins)
- Docker
- Self-hosted Docker Registry
- NGINX Web Server (inside Docker)
- Ubuntu / RHEL (Tested on EC2)

---

## 📁 Project Structure

my-docker-app/  
├── Dockerfile  
├── index.html  
└── Jenkinsfile  


---

## ✅ Setup Instructions

### 1. 🔧 Install Docker on Jenkins Host

#### Ubuntu
```bash
sudo apt update && sudo apt install -y docker.io
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker $USER
```
#### RHEL
```bash
sudo yum install -y docker
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker $USER
```
### 2. 🛠 Install Jenkins
#### Ubuntu
```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update && sudo apt install -y openjdk-17-jdk jenkins
```
#### RHEL
```bash
sudo yum install -y java-17-openjdk
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo yum install -y jenkins
```
#### Start Jenkins
```bash
sudo systemctl start jenkins && sudo systemctl enable jenkins
```

### 3. 🔐 Unlock Jenkins & Install Required Plugins
Visit: http://<jenkins_ip>:8080

#### Get password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
### Install these plugins:

Docker Pipeline

Git

Pipeline

Blue Ocean

### 4. 📦 Run Self-Hosted Docker Registry
```bash
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```
### 5. 📝 Sample Files
#### index.html
```bash
<!DOCTYPE html>  
<html>  
  <head><title>Jenkins Docker App</title></head>  
  <body>  
    <h1>🚀 Hello from Jenkins Docker Pipeline - NGINX is Running!</h1>  
  </body>  
</html>  
```
#### Dockerfile
```bash
FROM ubuntu:20.04

RUN apt update && apt install -y nginx curl

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```
### 6. 🧪 Jenkins Pipeline Configuration
#### Jenkinsfile
```bash
pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-nginx-app"
        REGISTRY = "localhost:5000"
        CONTAINER_NAME = "jenkins-nginx-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Gaurav10111/Automate-Docker-Image-Creation-and-Deployment-using-Jenkins-Pipeline.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $REGISTRY/$IMAGE_NAME:latest ."
                }
            }
        }

        stage('Push to Private Registry') {
            steps {
                script {
                    sh "docker push $REGISTRY/$IMAGE_NAME:latest"
                }
            }
        }

        stage('Run Container from Registry') {
            steps {
                script {
                    sh "docker rm -f $CONTAINER_NAME || true"
                    sh "docker pull $REGISTRY/$IMAGE_NAME:latest"
                    sh "docker run -d --name $CONTAINER_NAME -p 8081:80 $REGISTRY/$IMAGE_NAME:latest"
                }
            }
        }
    }
}
```
#### ⚠️ Challenges Faced & Solutions
Issue	Solution  
🔒 permission denied with Docker	Added Jenkins user to Docker group  
🌐 Port conflict (8080 used by Jenkins)	Changed NGINX container port to 8081  
🌿 Wrong Git branch (master by default)	Set branch: 'main' in Jenkinsfile  
🔑 GitHub auth issues	Used HTTPS instead of SSH to avoid key-based problems  

#### ✅ Final Outcome
After a successful Jenkins build:

Docker image is created and pushed to localhost:5000

NGINX container runs at http://<jenkins_ip>:8081

#### Browser shows:

🚀 Hello from Jenkins Docker Pipeline - NGINX is Running!

#### 🙌 Conclusion
This project shows how to:

Manually configure Docker + Jenkins

Create and manage private Docker registries

Automate CI/CD flows using real pipelines

Solve DevOps problems practically
