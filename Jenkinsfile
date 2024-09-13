pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'my-terraform-image'
        DOCKER_REGISTRY = 'docker.io' // Docker Hub URL
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Jenkins credentials ID for Docker
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with a specific tag
                    def customImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}") // Tag with build ID
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker registry
                    docker.withRegistry("https://${DOCKER_REGISTRY}", DOCKER_CREDENTIALS_ID) {
                        // Tag the built image
                        docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").tag("${DOCKER_IMAGE_NAME}:latest")

                        // Push the Docker image to Docker Hub
                        docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").push('latest')
                        docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").push("${env.BUILD_ID}") // Push tagged version
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Run Terraform init in the Docker container
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").inside {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform plan in the Docker container
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").inside {
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Run Terraform apply in the Docker container
                    docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").inside {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
    post {
        failure {
            echo 'Terraform scripts failed!'
        }
    }
}
