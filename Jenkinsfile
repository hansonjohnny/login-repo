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
                git branch: 'main', url: 'https://github.com/hansonjohnny/login-repo.git'
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

    }

    post {
        success {
            echo "Image successfully built and pushed to Docker Hub"
        }
        failure {
            echo "Pipeline FAILED"
        }
    }
}