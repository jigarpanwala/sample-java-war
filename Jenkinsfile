pipeline {
    agent any

    environment {
        // Docker Compose file path
        COMPOSE_FILE = 'docker-compose.yml'
        TOMCAT_CONTAINER = 'tomcat-server'  // Name of the Tomcat container
        MAVEN_CONTAINER = 'maven-build'    // Name of the Maven container
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from Git repository
                echo "Checking out ${env.BRANCH_NAME}"
                checkout scm
            }
        }

        stage('Build WAR') {
            steps {
                script {
                    echo 'Building WAR file with Maven'
                    // Build the Maven project to generate the WAR file
                    sh 'docker-compose run --rm maven mvn clean package -DskipTests'  // Run Maven inside the maven container
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    // Assuming the WAR file is in the target/ directory after build
                    def warFile = findFiles(glob: '**/target/*.war')[0].path
                    echo "Deploying ${warFile} to Tomcat container"

                    // Copy the WAR file to the Tomcat container
                    sh """
                        docker cp ${warFile} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/
                    """
                }
            }
        }

        stage('Restart Tomcat Container') {
            steps {
                script {
                    // Restart Tomcat container to pick up the new WAR file
                    echo 'Restarting Tomcat container'
                    sh "docker restart ${TOMCAT_CONTAINER}"
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
