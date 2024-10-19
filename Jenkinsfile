pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
        APP_NAME = 'reddit-clone-app'
        RELEASE = '1.0.0'
        DOCKER_USER = 'zunaied'
        DOCKER_PASS ='dockerhub-token'
        IMAGE_NAME = "${DOCKER_USER}"+"/"+"${APP_NAME}"
        IMAGE_TAG = "${RELEASE}.${BUILD_NUMBER}"
        SONARQUBE_SERVER='sonarqube-server'
        
    }
    stages{
        stage('Clean Workspace'){
            steps{
                cleanWs()
            }

        }

        stage('Checkout from GIT'){
            steps{
                git branch: 'main', url: 'https://github.com/Zunaied/a-reddit-clone.git'
            }
        }
        
        stage('Sonarqube Analysis'){
            steps{
                withSonarQubeEnv('sonarqube-server'){
                    sh '''$SCANNER_HOME/bin/sonar-scanner -X \
                        -Dsonar.projectname=reddit-clone-ci\
                        -Dsonar.projectKey=reddit-clone-ci \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://54.169.229.78:9000 \
                        -Dsonar.login=sqp_6e553fd8ffd62e40684f1b123aaf1e37b5cc670f'''
                }
            }
    }
    stage('Quality Gate'){
        steps{
            script{
                waitForQualityGate abortpipeline: false,credentialsId: 'sonarqube-token'
            }
        }

    }

    stage('Install dependencies'){
        steps{
            sh 'npm install'
        }

    }

     stage('Trivy FS Scan'){

        steps{
            sh "trivy fs . > trivyfs.txt"
        }
     }

    stage('Docker Build and push'){
        steps{
            script{
                docker.withRegistry('',DOCKER_PASS){
                    docker_image=docker.build "${IMAGE_NAME}"
                }
                docker.withRegistry('',DOCKER_PASS){
                    docker_image.push("${IMAGE_TAG}")
                    docker_image.push("latest")

                }
            }
        }
     }
     stage('Trivy Docker Image Scan'){

        steps{
            script{
                sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image zunaied/reddit-clone-app:latest --no-progress  --scanner vuln --exit-code 0 --severity HIGH, CRITICAL --format table > trivyimage.txt')
                
        }
     }
     }

     stage('Cleanup Artifactas'){
        steps {
            script {
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker rmi ${IMAGE_NAME}:latest"
            }
        }
     }
    }
}