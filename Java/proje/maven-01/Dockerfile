# Set the base image to use
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the pom.xml file
COPY pom.xml .

# Download the dependencies
RUN mvn dependency:go-offline

# Copy the project files
COPY src ./src

# Build the application
RUN mvn package assembly:single

# Create the final image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the JAR file from the build stage to the final image
COPY --from=build /usr/src/app/target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar .
# BUNU BEN EKLEDİM, içindeki dosyaları ekleyebiliyoruz.
COPY assets ./assets

# Specify the default command to run on container start
CMD ["java", "-jar", "my-app-1.0-SNAPSHOT-jar-with-dependencies.jar"]