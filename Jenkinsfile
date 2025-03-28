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
                        sed -i 's|image: tomcat:latest|image: tomcat:${env.BUILD_NUMBER}|g' deployment.yaml
                        ls
                        pwd
                        sudo -u ubuntu -i bash -c '
                         minikube kubectl -- apply -f deployment.yaml '

                    """
                }
            }
        }

    }

    post {
        success {
            echo 'Deployment to Tomcat container successful!'
        }
        failure {
            echo 'Deployment to Tomcat container failed.'
        }
    }
}
