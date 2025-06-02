pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'debabratap/rc-landing'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh '''
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
                npm install
                '''
            }
        }
        
        stage('Build') {
            steps {
                sh 'echo "Building application..."'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Deploy and Run Locally') {
            steps {
                sh '''
                export NVM_DIR="$HOME/.nvm"
                [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
                
                # Stop any existing container running on port 3000
                docker ps -q --filter "publish=3000" | xargs -r docker stop
                
                # Run the application locally using Docker
                docker run -d -p 3000:3000 --name rc-car-app ${DOCKER_IMAGE}:${DOCKER_TAG}
                
                echo "Application is now running at http://localhost:3000"
                '''
            }
        }
    }
    
    post {
        always {
            // sh 'docker logout || true'
            // cleanWs()
            echo" Cleaning up workspace..."
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
