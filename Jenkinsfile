pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('jenkins-creds')
        IMAGE_NAME = "hansonjohnny/login-app"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Repo') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                sh '''
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                    docker push hansonjohnny/login-app:latest
                '''
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl rollout status deployment/login-app
                '''
            }
        }

    }

}