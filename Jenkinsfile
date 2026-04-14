pipeline {
    agent any

    environment {
        DOCKER_CREDS  = credentials('jenkins-creds')
        IMAGE_NAME    = "hansonjohnny/login-app"
        IMAGE_TAG     = "${BUILD_NUMBER}"
        EKS_CLUSTER   = "my-cluster"
        AWS_REGION    = "us-east-2"
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
                    docker push $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }

        stage('Configure kubectl') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                        --region $AWS_REGION \
                        --name $EKS_CLUSTER
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl set image deployment/login-app login-app=$IMAGE_NAME:$IMAGE_TAG
                    kubectl rollout status deployment/login-app
                '''
            }
        }

    }

}