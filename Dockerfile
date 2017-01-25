# c9
FROM z3cka/debianvm:latest
MAINTAINER Casey Grzecka <c@sey.gr>

RUN apt update && apt install sudo

ARG c9port=80
ARG user=c9
ARG pass=rules
ARG workspace="/workspace"

ENV c9port $c9port
ENV user $user
ENV pass $pass
ENV workspace $workspace

RUN useradd --create-home --no-log-init --shell /bin/bash $user
RUN adduser $user sudo
RUN echo "$user:$pass" | chpasswd
USER $user
WORKDIR /home/$user

RUN echo "$pass" | sudo -S apt install -y build-essential gcc git make python2.7
# load nvm & desired node version
ENV NVM_DIR=$HOME/.nvm
RUN . $NVM_DIR/nvm.sh && nvm install v4.6.0 && nvm use stable

# get c9 and checkout temp fix for missing plugin
RUN sudo git clone https://github.com/c9/core.git /c9 && \
    sudo cd /c9 && \
    sudo scripts/install-sdk.sh

# use bash during build
RUN sudo -S rm /bin/sh && ln -s /bin/bash /bin/sh
# install some extra dev goodies like
# * apache support for older versions of php in apache via phpbrew
# * pip for installing CodeIntel in c9
RUN sudo -S apt install -y apache2-dev apt python-setuptools
RUN sudo -S easy_install pip
RUN sudo -S pip install -U pip
RUN sudo -S pip install -U virtualenv && \
    virtualenv --python=python2 $HOME/.c9/python2 && \
    source $HOME/.c9/python2/bin/activate
RUN sudo -S apt update && apt install -y python-dev
RUN sudo -S mkdir /tmp/codeintel && pip install --download /tmp/codeintel codeintel==0.9.3

# add hub 2.2.9
RUN sudo -S cd /opt && \
    wget https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz && \
    tar -zxvf hub-linux-amd64-2.2.9.tgz && \
    ln -s /opt/hub-linux-amd64-2.2.9/bin/hub /usr/local/bin/hub

RUN sudo -S mkdir /workspace

EXPOSE 80

CMD $HOME/.nvm/versions/node/v4.6.0/bin/node /c9/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
