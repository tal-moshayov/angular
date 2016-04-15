FROM node:5.4.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash 
RUN echo . ~/.nvm/nvm.sh >> $HOME/.bash_profile
ENV PATH $HOME/.nvm/bin:$PATH
RUN /bin/bash -c "source $HOME/.nvm/nvm.sh && nvm install 5.4.1"

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
    