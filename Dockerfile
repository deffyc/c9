# c9
FROM deffyc/debianvm:latest
MAINTAINER jiehou <deffyc@gmail.com>

RUN sudo mkdir $workspace

EXPOSE 80

CMD sudo -S $HOME/.nvm/versions/node/v4.6.0/bin/node /c9/server.js -p $c9port -a $user:$pass --listen 0.0.0.0 -w $workspace
