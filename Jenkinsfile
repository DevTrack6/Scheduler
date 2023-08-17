pipeline {
  agent none
  environment {
    IMG_NAME = "schedule"
    IMG_TAG = "latest"
    SERVER_IP = "223.130.130.247"
    REGISTRY_URL = "limeskin.kr.ncr.ntruss.com"
    NCP_ACCESS_KEY = credentials('NCP_ACCESS_KEY')
    NCP_SECRET_KEY = credentials('NCP_SECRET_KEY') 
    SSH_USERNAME = credentials('SSH_USERNAME')
    SSH_PASSWORD = credentials('SSH_PASSWORD')
  }
  stages{
    stage("build"){
      agent any
      steps{
        echo "build ${REGISTRY_URL}/$IMG_NAME:${IMG_TAG}"
        sh 'docker build -t ${REGISTRY_URL}/${IMG_NAME}:${IMG_TAG} scheduler'
      }
    }
    stage("push"){
      agent any
      steps{
        echo 'docker login'
        sh 'docker login -u ${NCP_ACCESS_KEY} -p ${NCP_SECRET_KEY} ${REGISTRY_URL}'

        echo 'docker push'
        sh 'docker push ${REGISTRY_URL}/${IMG_NAME}:${IMG_TAG}'
      }
    }
    stage("deploy"){
      agent any
      steps{
        echo 'connect ssh and deploy'
        sh 'mkdir -p ~/.ssh'
        sh 'ssh-keyscan -t rsa ${SERVER_IP} >> ~/.ssh/known_hosts'
        sh '''
          sshpass -p ${SSH_PASSWORD} ssh ${SSH_USERNAME}@${SERVER_IP} \
          "pwd
          ls -al"
        '''
      }
    }
  }
}