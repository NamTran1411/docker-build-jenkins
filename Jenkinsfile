pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }

    stages {
         stage ("SSH Agent"){
               steps {
                sshagent(['ssh-remote']) {
               sh '''
                        ssh -o StrictHostKeyChecking=no -l adminlc 192.168.64.2 'cd ./Documents/docker-build-jenkins && git pull origin main && docker compose build'
                    '''

            }
         }
         }
    }

    post {
        success {
            echo "SUCCESSFUL"
        }
        failure {
            echo "FAILED"
        }
    }
}