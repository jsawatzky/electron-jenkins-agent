FROM ghcr.io/jsawatzky/npm-jenkins-agent:latest

LABEL org.opencontainers.image.source https://github.com/jsawatzky/electron-jenkins-agent

USER root

RUN apk add --update --no-cache openjpeg-dev wine
RUN ln -s /usr/bin/wine64 /usr/bin/wine

RUN curl -L https://github.com/electron-userland/electron-builder-binaries/releases/download/wine-2.0.3-mac-10.13/wine-home.zip > /tmp/wine-home.zip \
    && unzip /tmp/wine-home.zip -d /home/jenkins/.wine \
    && chown -R jenkins:jenkins /home/jenkins/.wine \
    && unlink /tmp/wine-home.zip

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d

USER jenkins
