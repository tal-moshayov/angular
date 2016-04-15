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

#https://github.com/npm/npm/issues/9863#issuecomment-209194124
RUN echo "root: $(npm root -g)"
RUN cd $(npm root -g)/npm && npm install fs-extra 
RUN echo "new root: $(npm root -g)"
RUN cd $(npm root -g) && sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs\.move/ ./lib/utils/rename.js
RUN npm install -g npm@3.5.3
RUN npm version

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
RUN npm install -g bower tsd

# bower cache
ADD ./bower.json ./
RUN bower install --allow-root

COPY . /usr/src/app

# http://stackoverflow.com/questions/30549163/angular2-build-process-fails
#RUN cd tools && npm install
RUN cd tools && tsd install