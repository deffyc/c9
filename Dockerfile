# Cloud9
FROM deffyc/debianvm:latest
MAINTAINER houjie <deffyc@gmail.com>

ARG c9port=80
ARG workspace=/home/c9/workspace
ENV c9port $c9port
ENV workspace $workspace

RUN sudo apt update && sudo apt install -y git
# load nvm & desired node version
ENV NVM_DIR /home/$user/.nvm

RUN . $NVM_DIR/nvm.sh && nvm install v4.6.0 && nvm use stable

# get c9 and checkout temp fix for missing plugin
RUN git clone https://github.com/c9/core.git $HOME/c9sdk && \
    cd $HOME/c9sdk && \
    scripts/install-sdk.sh

RUN sudo mkdir $workspace

EXPOSE 80
EXPOSE 3000

CMD  sudo $HOME/.nvm/versions/node/v4.6.0/bin/node $HOME/c9sdk/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
