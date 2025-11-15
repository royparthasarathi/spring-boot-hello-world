pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  environment {
    DOCKERHUB_REPO = "royparthasarathi/newme-shopee"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    AWS_REGION = "ap-south-1"
    TERRAFORM_DIR = "infra"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (Maven)') {
      steps {
        sh "mvn -B -DskipTests package"
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build("${env.DOCKERHUB_REPO}:${IMAGE_TAG}")
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTIALS', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh """
            echo $DH_PASS | docker login -u $DH_USER --password-stdin
            docker tag ${env.DOCKERHUB_REPO}:${IMAGE_TAG} ${env.DOCKERHUB_REPO}:latest
            docker push ${env.DOCKERHUB_REPO}:${IMAGE_TAG}
            docker push ${env.DOCKERHUB_REPO}:latest
          """
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_CREDENTIALS']]) {
          dir("${TERRAFORM_DIR}") {
            sh '''
              terraform init -input=false
              terraform apply -auto-approve -var="docker_image_tag=${IMAGE_TAG}"
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo "Deployment Successful"
    }
    failure {
      echo "Build or Deployment Failed"
    }
  }
}
