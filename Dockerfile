FROM openjdk:8-jre-slim

RUN apt-get update \
    && apt-get install -y wget \
    && wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar  \
    && chmod +x opentelemetry-javaagent.jar 

COPY ./target/spring-petclinic-2.4.5.jar /app/spring-petclinic.jar
COPY ./opentelemetry-javaagent.jar  /app/opentelemetry-javaagent.jar

ENTRYPOINT ["java","-javaagent:/app/opentelemetry-javaagent.jar","-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap",  "-Djava.security.egd=file:/dev/./urandom",  "-Dotel.javaagent.debug=true", "-jar", "/app/spring-petclinic.jar"]
