pipeline {
    agent any
    
    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '270311159384'
        ECR_REPO = 'myrepo'
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build('httpd')
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        docker.withRegistry("https://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com", 'ecr') {
                            docker.image("httpd").push("${ECR_REPO}:latest")
                        }
                    }
                }
            }
        }
    }
}
