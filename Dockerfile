FROM openjdk:17
EXPOSE 8080
ADD target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar"]
