FROM maven:3.8-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project files (pom.xml and others) into the container
COPY . /app

# Run Maven to build the project (WAR file will be placed in /app/target)
RUN mvn clean package -DskipTests

FROM tomcat:9-jdk11-openjdk

# Set the working directory to Tomcat's webapps folder
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file from the Maven build stage into Tomcat's webapps directory
COPY --from=build /app/target/hello-1.0.war /usr/local/tomcat/webapps/hello-app.war

# Expose Tomcat's port
EXPOSE 8080

# Run Tomcat by default
CMD ["catalina.sh", "run"]
