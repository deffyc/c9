# c9
FROM deffyc/debianvm:latest
MAINTAINER jiehou <deffyc@gmail.com>

RUN . $NVM_DIR/nvm.sh && nvm install v4.6.0 && nvm use stable

# get c9 and checkout temp fix for missing plugin
RUN sudo git clone https://github.com/c9/core.git /c9 && \
    cd /c9 && \
    sudo scripts/install-sdk.sh

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
    sudo source $HOME/.c9/python2/bin/activate
RUN sudo apt update && sudo apt install -y python-dev
RUN sudo mkdir /tmp/codeintel && sudo pip install --download /tmp/codeintel codeintel==0.9.3



RUN sudo mkdir $workspace

EXPOSE 80

CMD sudo -S $HOME/.nvm/versions/node/v4.6.0/bin/node /c9/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
