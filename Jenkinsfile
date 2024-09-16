pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Mansi123098/dockerjentf2.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('my-terraform-image:2')
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://docker.io', 'docker-credentials-id') {
                        docker.image('my-terraform-image:2').push()
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
