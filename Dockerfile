# Stage 1: Build the JAR inside the container

FROM maven:3.9.5-eclipse-temurin-17 AS builder

WORKDIR /workspace

# Copy Maven config and source code
COPY pom.xml .
COPY src/ ./src/

# Build the Spring Boot application

RUN mvn clean package -DskipTests

# Stage 2: Use a slim runtime image for deployment

FROM eclipse-temurin:17-jre-jammy

LABEL maintainer="amadou.diallo@b-hitech.com"
LABEL application="FoodFrenzy"

WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /workspace/target/*.jar app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
