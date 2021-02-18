String credentialsId = 'aws-id'

try {
  stage('checkout scm') {
    node {
      cleanWs()
      checkout scm
    }
  }

    stage('check docker') {
      node {
            sh 'docker --version'
      }
    }
    
    stage('docker build & push') {
      node {
          checkout scm
          dir("client") {
              docker.withRegistry('', 'docker-hub-id') {
                def customImage = docker.build("markopajkic/devopsclient1")
                customImage.push()
              }
          }
        }
    }

  stage('terraform init') {
    node {
        checkout scm
        dir("web-server") {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: credentialsId,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
          ]]) {
              sh 'terraform init'
          }
        }
      }

  stage('terraform plan') {
    node {
        checkout scm
        dir("web-server") {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: aws-id,
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
          ]]) {
              sh 'terraform plan'
          }
        }
      }
  } 

  
  currentBuild.result = 'SUCCESS'
}
catch (org.jenkinsci.plugins.workflow.steps.FlowInterruptedException flowError) {
  currentBuild.result = 'ABORTED'
}
catch (err) {
  currentBuild.result = 'FAILURE'
  throw err
}
finally {
  if (currentBuild.result == 'SUCCESS') {
    currentBuild.result = 'SUCCESS'
  }
}