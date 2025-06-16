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
                git 'https://github.com/Gaurav10111/Automate-Docker-Image-Creation-and-Deployment-using-Jenkins-Pipeline.git'  // or use local Git repo
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
                    // Remove if already running
                    sh "docker rm -f $CONTAINER_NAME || true"

                    // Pull image from private registry (optional since you just pushed)
                    sh "docker pull $REGISTRY/$IMAGE_NAME:latest"

                    // Run container
                    sh "docker run -d --name $CONTAINER_NAME -p 8080:80 $REGISTRY/$IMAGE_NAME:latest"
                }
            }
        }
    }
}

