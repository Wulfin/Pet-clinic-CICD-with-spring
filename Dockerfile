FROM openjdk:latest

WORKDIR app/

ADD target/spring-petclinic-2.1.0.war app.war

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.war"]
