FROM maven:3.6.0-jdk-11-slim AS build

COPY . /home/app

WORKDIR /home/app

RUN mvn clean package

From tomcat:9.0.56-jdk11-temurin-focal

RUN date

ENV TZ=Asia/Calcutta

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN date

ARG PORT="8080"

RUN echo ${PORT}

RUN sed -i "s/8080/${PORT}/" ${CATALINA_HOME}/conf/server.xml

RUN mkdir -p -v /usr/local/download

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /home/app/target/*.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh","run"]
