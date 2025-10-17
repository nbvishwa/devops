# Use Maven + JDK pre-installed
FROM maven:3.9.3-eclipse-temurin-20

WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the project without running tests
RUN mvn -B install -DskipTests

# Default command to run tests at runtime
CMD ["mvn", "test"]
