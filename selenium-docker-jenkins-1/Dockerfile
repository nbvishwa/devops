# Use Maven + JDK pre-installed
FROM maven:3.9.3-eclipse-temurin-20

WORKDIR /app

# Copy project files (for build-time)
COPY pom.xml .
COPY src ./src

# Build the project without running tests
RUN mvn -B install -DskipTests

# Default command to run tests at runtime
# This will work whether files are copied or volume-mounted
CMD ["sh", "-c", "if [ -f pom.xml ]; then mvn test; else echo 'No pom.xml found in /app directory'; exit 1; fi"]
