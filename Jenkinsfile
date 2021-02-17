pipeline {

    agent any

    enviroment {
        dockerImage = ''
        registry = 'markopajkic/clientdevops'
    }

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

        stage('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build registry
                }
            }
        }
    }
}