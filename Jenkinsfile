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
        stage('Increment Version') {
            steps {
                script {
                    // Check if the version file exists
                    if (!fileExists(env.VERSION_FILE)) {
                        // If not, create the file with the initial version
                        writeFile file: env.VERSION_FILE, text: '0.0.1'
                    }
                    // Read the current version
                    def currentVersion = readFile(file: env.VERSION_FILE).trim()
                    // Increment the version (example: increment the patch part)
                    def (major, minor, patch) = currentVersion.tokenize('.')
                    def newVersion = "${major}.${minor}.${Integer.parseInt(patch) + 1}"
                    // Write the new version to the file
                    writeFile file: env.VERSION_FILE, text: newVersion
                    // Set an environment variable VERSION
                    env.VERSION = newVersion
                }
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
