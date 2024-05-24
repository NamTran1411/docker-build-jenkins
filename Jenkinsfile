pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }
    environment {
        // Tạo version dựa trên timestamp
        IMAGE_VERSION = "${env.BUILD_ID}"
    }
    stages {
         stage('Prepare') {
            steps {
                script {
                    // Hoặc sử dụng git commit hash
                    IMAGE_VERSION = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    echo "Using IMAGE_VERSION: ${IMAGE_VERSION}"
                }
            }
        }
         stage ("SSH Server"){
               steps {
                sshagent(['ssh-remote']) {
               sh '''
                        ssh -o StrictHostKeyChecking=no -l adminlc 192.168.64.2 'cd ./Documents/docker-build-jenkins && git pull origin main &&
                        docker compose build --build-arg VERSION=${IMAGE_VERSION} &&
                         docker compose up -d'
                    '''
            }
         }
         }
    }

}