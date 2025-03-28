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
                    # Build Docker image with Jenkins build number
                    docker build -t tomcat:${env.BUILD_NUMBER} .
                    docker push jigarpanwala/tomcat:${env.BUILD_NUMBER}

                    # Update the deployment.yaml file to use the new image tag
                    sed -i "s|image: tomcat:latest|image: tomcat:${env.BUILD_NUMBER}|g" deployment.yaml

                    # List files and print the working directory for debugging
                    ls
                    pwd

                    # Apply the deployment.yaml using minikube's kubectl as the 'ubuntu' user
                    sudo -u ubuntu -i bash -c 'minikube kubectl -- apply -f /var/lib/jenkins/workspace/Tomcat-JAVA-CICD_Deploy_K8s_2/deployment.yaml'
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
