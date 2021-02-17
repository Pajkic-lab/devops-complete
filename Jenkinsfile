pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Pajkic-lab/devops-complete']]])
            }
        }

        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
    }
}