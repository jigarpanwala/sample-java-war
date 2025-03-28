pipeline {
    agent any

    stages {
        
        stage('Checkout') {
            steps {
                echo "Checking out ${env.BRANCH_NAME}"
                checkout scm
            }
        }

        stage('Build Docker Container') {
            steps {
                def imageTag = "tomcat:${env.BUILD_NUMBER}"
                script {
                    sh """
                        docker build -t ${imageTag} .
                        docker run -d -p 8082:8080 ${imageTag}
                    """
                }
            }
        }

    }

    post {
        always {
            echo 'Cleaning up the workspace...'
            cleanWs()  // This will clean the workspace after the pipeline run
        }
        success {
            echo 'Deployment to Tomcat container successful!'
        }
        failure {
            echo 'Deployment to Tomcat container failed.'
        }
    }
}
