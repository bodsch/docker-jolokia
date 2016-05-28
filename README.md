# docker-jolokia

Minmal Image with Apache Tomcat8, openjdk8-jre-base and jolokia.

## versions

 - tomcat 8.5.2
 - jolokia 1.3.3
 - openjdk from alpine

## Build

 ```
 docker build --tag=docker-jolokia .
 ```
 or

 ```
 ./build.sh
 ```

## run

 ```
 docker run docker-jolokia
 ```
 or

 ```
 ./run.sh
 ```

## Test

 ```
 curl http://localhost:8080/jolokia/ | python -mjson.tool
 ```

## Ports

* 8080

