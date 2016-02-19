# docker-jolokia

Minmal Image with Apache Tomcat8, openjdk7-jre and jolokia. Built starting from [gliderlabs' alpine][alpine]

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

[alpine]: <https://github.com/gliderlabs/docker-alpine>

