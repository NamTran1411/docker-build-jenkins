pipeline {
    agent any

    tools {
        nodejs "nodejs"
    }
    stages {
        stage ("SSH Server"){
            steps {
                sshagent(credentials: ['ssh-remote']) {
                   sh 'chmod +x build_docker.sh'
                    // Run the Bash script
                   sh './build_docker.sh'
                }
            }
        }
    }
}
