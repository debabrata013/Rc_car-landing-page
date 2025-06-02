pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'echo "Installing dependencies..."'
                // Commented out for testing
                // sh 'npm install'
            }
        }
        
        stage('Build') {
            steps {
                sh 'echo "Building application..."'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
        }
    }
}

