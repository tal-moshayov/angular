FROM node:latest

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update
RUN apt-get -y install software-properties-common python-software-properties
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -y install g++-4.8
RUN apt-get -y install default-jdk
RUN apt-get install -y curl patch vim xvfb unzip apt-transport-https 

# Install firefox 38.0
RUN wget https://ftp.mozilla.org/pub/firefox/releases/38.0/linux-x86_64/en-US/firefox-38.0.tar.bz2 \
    && tar -xjvf firefox-38.0.tar.bz2 \
    && rm -rf /opt/firefox-* \
    && mv firefox /opt/firefox-38.0 \
    && ln -sf /opt/firefox-38.0/firefox /usr/bin/firefox

# chromium
ADD ./scripts/ci/install_chromium.sh /tmp/ 
RUN chmod +x /tmp/install_chromium.sh
RUN /tmp/install_chromium.sh

# dart
ADD ./scripts/ci/install_dart.sh /tmp/
RUN chmod +x /tmp/install_dart.sh
RUN /tmp/install_dart.sh stable latest linux-x64

# npm install (Cached yeepee!)
ADD ./package.json /usr/src/app/
RUN npm cache clean
RUN npm install
npm install -g npm@3.5.3


COPY . /usr/src/app