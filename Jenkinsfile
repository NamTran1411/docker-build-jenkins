pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }

    environment {
        VERSION_FILE = 'version.txt'  // Path to the version file
    }

    stages {
        stage('Run Version Script and Build Docker Image') {
            steps {
                sh './increment_version.sh'
            }
        }
        stage ("SSH Server"){
            steps {
                sshagent(credentials: ['ssh-remote']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no adminlc@192.168.64.2 '
                            cd ./Documents/docker-build-jenkins &&
                            git pull origin main &&
                            docker compose build --build-arg VERSION=${env.VERSION} &&
                            docker compose up -d
                        '
                    '''
                }
            }
        }
    }
}
