pipeline {

    agent any

    environment {
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

        stage('PWD') {
            steps {
                script {
                    echo "$PWD"
                }
            }
        }

        stage('Docker version') {
            steps {
                script {
                    docker --version
                }
            }
        }
    }
}