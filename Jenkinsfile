pipeline {
    agent any

    environment {
        MAVEN_IMAGE = 'maven:3.8-openjdk-11'        // Maven Docker image
        TOMCAT_IMAGE = 'tomcat:9-jdk11-openjdk'     // Tomcat Docker image
        WAR_FILE_PATH = './target/hello-1.0.war'    // Path to your WAR file
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
                    sh """
                        docker build -f Dockerfile.maven -t maven-build .
                        docker run --rm -v \$(pwd)/target:/app/target maven-build mvn package
                    """
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    echo 'Deploying WAR to Tomcat container'
                    
                    sh """
                        docker ps -q -f name=tomcat-server | xargs -r docker stop
                        docker ps -aq -f name=tomcat-server | xargs -r docker rm
                    """

                    sh """
                        docker run -d --name tomcat-server -v \$(pwd)/webapps:/usr/local/tomcat/webapps -p 8081:8080 ${TOMCAT_IMAGE}
                    """

                    sh """
                        docker cp ${WAR_FILE_PATH} tomcat-server:/usr/local/tomcat/webapps/
                    """
                }
            }
        }

        stage('Restart Tomcat') {
            steps {
                script {
                    echo 'Restarting Tomcat container to load the new WAR'
                    sh 'docker restart tomcat-server'
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
