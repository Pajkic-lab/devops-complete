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

    stage('docker test') {
      node {
          checkout scm
          dir("client") {
          sh "docker build -t markopajkic/reactapp ."
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