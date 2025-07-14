# Stage 1: Build with Maven and download dependencies separately
FROM maven:3.9.5-eclipse-temurin-17 AS builder
WORKDIR /workspace
COPY pom.xml .
# Download dependencies only
RUN mvn dependency:go-offline -B
COPY src/ ./src/
# Package application (skip tests for speed)
RUN mvn clean package -DskipTests -B

# Stage 2: Run on minimal Alpine-based JRE, non-root user
FROM eclipse-temurin:17-jre-alpine AS runtime
# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
# Copy built JAR from builder stage
COPY --from=builder /workspace/target/*.jar app.jar
# Expose application port
EXPOSE 8080
# Healthcheck for container readiness
HEALTHCHECK --interval=30s --timeout=5s CMD wget --quiet --spider http://localhost:8080/actuator/health || exit 1
# Use JAVA_OPTS for flexibility
USER appuser
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]

