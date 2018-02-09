# c9 
FROM debian:jessie
MAINTAINER houjie <deffyc@gmail.com>

ARG c9port=8080
ARG workspace=/workspace
ARG user=c9
ARG pass=rules

ENV c9port $c9port
ENV workspace $workspace
ENV user $user
ENV pass $pass

RUN apt update && apt install -y curl wget vim

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

RUN apt update && apt install -y build-essential gcc git make python2.7
# load nvm & desired node version
ENV NVM_DIR=/root/.nvm

RUN . $NVM_DIR/nvm.sh && nvm install v4.4.6 && nvm use 4

# get c9 and checkout temp fix for missing plugin
RUN git clone https://github.com/c9/core.git /c9 && \
    cd /c9 && \
    scripts/install-sdk.sh
RUN mkdir $workspace

EXPOSE 8080
EXPOSE 3000
EXPOSE 80
CMD /root/.nvm/versions/node/v4.4.6/bin/node /c9/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
