pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }

    stages {

         stage ("SSH Agent"){
               steps {
                sshagent(['ssh-agent-admin']) {
               sh '''
                        ssh -o StrictHostKeyChecking=no -l adminlc 192.168.64.2 'cd /var/www/loginLC && pm2 reload all && cd && ftp 192.168.64.2'
                    '''

            }
         }
         }
        stage("install") {
            steps {
                sh 'npm install'
            }
        }
        stage("build") {
            steps {
                sh 'npm run build'
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