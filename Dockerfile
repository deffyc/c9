# Cloud9
FROM deffyc/debianvm:latest
MAINTAINER houjie <deffyc@gmail.com>

ARG c9port=8080
ARG workspace=/workspace
ENV c9port $c9port
ENV workspace $workspace

RUN sudo apt update && sudo apt install -y build-essential gcc git make python2.7
# load nvm & desired node version
ENV NVM_DIR=/root/.nvm

RUN . $NVM_DIR/nvm.sh && nvm install v4.6.0 && nvm use stable

# get c9 and checkout temp fix for missing plugin
RUN git clone https://github.com/c9/core.git /c9 && \
    cd /c9 && \
    scripts/install-sdk.sh

RUN sudo mkdir $workspace

EXPOSE 8080
EXPOSE 3000
EXPOSE 80
CMD  sudo /root/.nvm/versions/node/v4.6.0/bin/node /c9/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
