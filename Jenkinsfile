try {
  stage('checkout') {
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
    
    stage('check docker secret') {
      node {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-id',
        usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {

        sh 'echo uname=$USERNAME pwd=$PASSWORD'
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