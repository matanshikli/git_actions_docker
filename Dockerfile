FROM ubuntu:20.04

RUN apt-get update

COPY echo.sh /opt/echo.sh

ENTRYPOINT bash /opt/echo.sh