FROM jenkins/agent:latest

LABEL org.opencontainers.image.source https://github.com/jsawatzky/electron-jenkins-agent

USER root

# Installed required packages
RUN apt-get -qq update \
    && apt-get -qq install --no-install-recommends \
        qtbase5-dev build-essential autoconf libssl-dev gcc-multilib g++-multilib \
        lzip rpm python libcurl4 git git-lfs ssh unzip libarchive-tools \
        libxtst6 libsecret-1-dev libopenjp2-tools curl gettext-base \
    && apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

# Intall NodeJS
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Install wine - pulled from https://github.com/electron-userland/electron-builder/blob/master/docker/wine/Dockerfile
RUN dpkg --add-architecture i386 && \
  curl -Lo /usr/share/keyrings/winehq.asc https://dl.winehq.org/wine-builds/winehq.key && \
  echo 'deb [signed-by=/usr/share/keyrings/winehq.asc] https://dl.winehq.org/wine-builds/ubuntu/ focal main' > /etc/apt/sources.list.d/winehq.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends winehq-stable && \
  apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -L https://github.com/electron-userland/electron-builder-binaries/releases/download/wine-2.0.3-mac-10.13/wine-home.zip > /tmp/wine-home.zip \
    && unzip /tmp/wine-home.zip -d /home/jenkins/.wine \
    && chown -R jenkins:jenkins /home/jenkins/.wine \
    && unlink /tmp/wine-home.zip

ENV WINEDEBUG -all,err+all
ENV WINEDLLOVERRIDES winemenubuilder.exe=d

USER jenkins
