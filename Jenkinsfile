pipeline {
    agent any

    tools {
        maven 'mvn'
        jdk 'jdk'
    }

    environment {
        DOCKER_CREDS = credentials('jenkins-creds')
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

        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t hansonjohnny/login-app .'
            }
        }

        stage('Docker Push') {
            steps {
                sh '''
                    echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                    docker push hansonjohnny/login-app
                '''
            }
        }

    }
}