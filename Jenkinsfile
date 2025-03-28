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
                script {
                    sh """
                        docker build -t tomcat:${env.BUILD_NUMBER} .
                        alias kubectl="minikube kubectl --"
                        sed -i 's|image: tomcat:latest|image: tomcat:${env.BUILD_NUMBER}|g' deployment.yaml
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
