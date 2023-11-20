# Stage 1:
FROM maven:latest AS builder

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn package

# Stage 2: 
FROM openjdk:latest

WORKDIR /app

COPY --from=builder /target/spring-petclinic-2.1.0.war /app/app.war

EXPOSE 8080

CMD ["java", "-jar", "app.war"]
