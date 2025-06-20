pipeline {
     agent any
     environment {
        GHCR_CREDENTIALS = credentials("tomwey2-ghcr")
     }
     stages {
        stage("initialize") {
            steps {
                sh "env"
                sh "mvn --version"
                sh "java -version"
            }
        }
        stage("Docker build") {
            steps {
                sh "docker build -t ghcr.io/tomwey2/jenkins-agent:latest ."
                sh "docker login --username $GHCR_CREDENTIALS_USR --password $GHCR_CREDENTIALS_PSW ghcr.io"
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