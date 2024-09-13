pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'my-terraform-image' // Ensure this is a valid Docker name
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
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
                    // Ensure BUILD_ID is a valid tag, e.g., a number or alphanumeric string
                    def buildTag = "${env.BUILD_ID}".replaceAll("[^a-zA-Z0-9_-]", "_")
                    def customImage = docker.build("${DOCKER_IMAGE_NAME}:${buildTag}")
                    echo "Built Docker image with tag ${DOCKER_IMAGE_NAME}:${buildTag}"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", DOCKER_CREDENTIALS_ID) {
                        def buildTag = "${env.BUILD_ID}".replaceAll("[^a-zA-Z0-9_-]", "_")
                        def image = docker.image("${DOCKER_IMAGE_NAME}:${buildTag}")
                        
                        // Tag the built image as 'latest'
                        image.tag("${DOCKER_IMAGE_NAME}:latest")
                        echo "Tagged Docker image as ${DOCKER_IMAGE_NAME}:latest"
                        
                        // Push the Docker image to Docker Hub
                        image.push('latest')
                        echo "Pushed Docker image with tag latest"
                        
                        // Push the Docker image with the build ID tag
                        image.push("${buildTag}")
                        echo "Pushed Docker image with tag ${buildTag}"
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    def buildTag = "${env.BUILD_ID}".replaceAll("[^a-zA-Z0-9_-]", "_")
                    docker.image("${DOCKER_IMAGE_NAME}:${buildTag}").inside {
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    def buildTag = "${env.BUILD_ID}".replaceAll("[^a-zA-Z0-9_-]", "_")
                    docker.image("${DOCKER_IMAGE_NAME}:${buildTag}").inside {
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
