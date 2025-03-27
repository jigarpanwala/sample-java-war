pipeline {
    agent any

    environment {
        MAVEN_IMAGE = 'maven:3.8-openjdk-11'   // Maven Docker image
        TOMCAT_IMAGE = 'tomcat:9-jdk11-openjdk'  // Tomcat Docker image
        WAR_FILE_PATH = './target/hello-1.0.war'  // Correct path to your WAR file
        TOMCAT_CONTAINER = 'tomcat-server'  // Tomcat container name
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out ${env.BRANCH_NAME}"
                checkout scm
            }
        }

        stage('Build WAR') {
            steps {
                script {
                    echo 'Building WAR file with Maven using Docker'
                    
                    // Build the WAR file using Maven inside the Maven container
                    sh """
                        docker build -f Dockerfile.maven -t maven-build .
                        docker run --rm -v \$(pwd)/target:/app/target maven-build mvn clean package
                    """
                }
            }
        }

        stage('Stop and Remove Existing Tomcat Container') {
            steps {
                script {
                    echo 'Stopping and removing any existing Tomcat container'
                    
                    // Stop and remove any running Tomcat container
                    sh """
                        docker ps -q -f name=${TOMCAT_CONTAINER} | xargs -r docker stop
                        docker ps -aq -f name=${TOMCAT_CONTAINER} | xargs -r docker rm
                    """
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    echo 'Deploying WAR to Tomcat container'

                    // Run the Tomcat container with the latest WAR file
                    sh """
                        docker run -d --name ${TOMCAT_CONTAINER} -v \$(pwd)/webapps:/usr/local/tomcat/webapps -p 8081:8080 ${TOMCAT_IMAGE}
                    """

                    // Ensure WAR file is copied correctly into the Tomcat webapps directory
                    sh """
                        docker cp ${WAR_FILE_PATH} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/
                    """
                }
            }
        }

        stage('Restart Tomcat') {
            steps {
                script {
                    echo 'Restarting Tomcat container to load the new WAR'
                    // Restart Tomcat container to pick up the new WAR file
                    sh 'docker restart ${TOMCAT_CONTAINER}'
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
