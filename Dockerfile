# Use a lightweight OpenJDK 17 base image
FROM openjdk:17-jdk-slim


# Set working directory inside the container
WORKDIR /app

# Copy the JAR file built by Maven into the container
# Assumes the JAR is built under target/ directory
COPY target/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
