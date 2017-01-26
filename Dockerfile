# Cloud9
FROM deffyc/debianvm:latest
MAINTAINER houjie <deffyc@gmail.com>

ARG c9port=80
ARG workspace=/home/c9/workspace
ENV c9port $c9port
ENV workspace $workspace


RUN sudo apt update && sudo apt install -y build-essential gcc git make python2.7
# load nvm & desired node version
ENV NVM_DIR /home/$user/.nvm

RUN . $NVM_DIR/nvm.sh && nvm install v4.6.0 && nvm use stable

# get c9 and checkout temp fix for missing plugin
RUN git clone https://github.com/c9/core.git $HOME/c9sdk && \
    cd $HOME/c9sdk && \
    scripts/install-sdk.sh

# use bash during build
RUN sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh
# install some extra dev goodies like
# * apache support for older versions of php in apache via phpbrew
# * pip for installing CodeIntel in c9
RUN sudo apt install -y apache2-dev apt python-setuptools
RUN sudo easy_install pip
RUN sudo pip install -U pip
RUN sudo pip install -U virtualenv && \
    sudo virtualenv --python=python2 $HOME/.c9/python2 && \
    source $HOME/.c9/python2/bin/activate
RUN sudo apt update && sudo apt install -y python-dev
RUN sudo mkdir /tmp/codeintel && sudo pip install --download /tmp/codeintel codeintel==0.9.3

RUN sudo mkdir $workspace

EXPOSE 80

RUN curl https://install.meteor.com/ | sh
	
RUN meteor npm config set registry http://registry.npm.taobao.org/

CMD  sudo $HOME/.nvm/versions/node/v4.6.0/bin/node $HOME/c9sdk/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
