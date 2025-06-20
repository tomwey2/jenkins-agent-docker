pipeline {
     agent any
     environment {
        GHCR_CREDENTIALS = credentials("tomwey2-ghcr")
        IMAGE_VERSION = '1.1.0'
     }
     stages {
        stage("initialize") {
            steps {
                sh "env"
                sh "java -version"
            }
        }
        stage("Docker build") {
            steps {
                sh "docker build -t ghcr.io/tomwey2/jenkins-agent:$IMAGE_VERSION -t ghcr.io/tomwey2/jenkins-agent:latest ."
            }
        }
        stage("Docker push") {
            steps {
                sh "docker login --username $GHCR_CREDENTIALS_USR --password $GHCR_CREDENTIALS_PSW ghcr.io"
                sh "docker push ghcr.io/tomwey2/jenkins-agent:$IMAGE_VERSION"
                sh "docker push ghcr.io/tomwey2/jenkins-agent:latest"
            }
        }
    }
    post {
        always {
            sh "docker logout"
        }
    }
 }