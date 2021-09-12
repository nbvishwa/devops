FROM java

WORKDIR /app

COPY . .

ENTRYPOINT java -Xmx256m -jar spring-petclinic-2.5.0-SNAPSHOT.jar --server.port=8080
