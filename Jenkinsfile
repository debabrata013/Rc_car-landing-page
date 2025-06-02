pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'debabratap/rc-landing'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'echo "Linting code..." # Replace with actual linting command when you add it'
                // Example: sh 'npm run lint'
            }
        }
        
        stage('Test') {
            steps {
                sh 'echo "Running tests..." # Replace with actual test command when you add tests'
                // Example: sh 'npm test'
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
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
        
        stage('Deploy to Development') {
            when {
                branch 'develop'
            }
            steps {
                sh 'echo "Deploying to development environment..."'
                // Add deployment steps for dev environment
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'master'
            }
            steps {
                sh 'echo "Deploying to production environment..."'
                // Add deployment steps for production environment
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
