#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/crawler-src/src
COPY libs /home/crawler-src/libs
COPY pom.xml /home/crawler-src
RUN mvn -f /home/crawler-src/pom.xml clean assembly:assembly

#
# Package stage
#
FROM openjdk:???
COPY --from=build /home/crawler-src/target/cc-lod-crawler-DockerApplication /home/crawler/
ENTRYPOINT ["/bin/sh","/home/crawler/ScriptTestDocker.sh"]