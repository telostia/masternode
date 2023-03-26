FROM ubuntu:trusty

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y \
  libzmq3-dev \
  libzmq3-dbg \
  libzmq3 \
  software-properties-common \
  curl \
  build-essential \
  libssl-dev \
  wget \
  libtool \
  autotools-dev \
  automake \
  pkg-config \
  libssl-dev \
  libevent-dev \
  bsdmainutils \
  git \
  vim

RUN add-apt-repository ppa:bitcoin/bitcoin -y
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

RUN apt-get install -y \
  libboost-system-dev \
  libboost-filesystem-dev \
  libboost-chrono-dev \
  libboost-program-options-dev \
  libboost-test-dev \
  libboost-thread-dev

# If you need to rebuild node from source.
# RUN git clone https://github.com/raven-dark/raven-dark.git && \
#  cd raven-dark && \
#  ./autogen.sh && \
#  ./configure --without-gui && make

ENV VERSION=0.3.2

#RUN mkdir /ravendark

RUN wget https://github.com/raven-dark/raven-dark/archive/0.3.2.tar.gz && tar -xf 0.3.2.tar.gz  && cd raven-dark-0.3.2 && chmod +x autogen.sh && chmod +x share/genbuild.sh && chmod +x ./src/leveldb/build_detect_platform && ./autogen.sh && ./configure --with-pic --without-gui --without-miniupnpc --disable-tests --disable-bench --disable-zmq --disable-maintainer-mode  --disable-miner && make

#RUN wget -qO- https://github.com/raven-dark/raven-dark/releases/download/${VERSION}/ravendarkd-v${VERSION}-ubuntu-trusty.tar.gz | tar xvz -C /ravendark

RUN chmod +x /raven-dark-0.3.2/src/ravendarkd
RUN chmod +x /raven-dark-0.3.2/src/ravendark-cli

RUN ln -sf /raven-dark-0.3.2/src/ravendarkd /usr/bin/ravendarkd
RUN ln -sf /raven-dark-0.3.2/src/ravendark-cli /usr/bin/ravendark-cli

RUN apt-get autoclean && \
  apt-get autoremove -y

RUN mkdir -p /root/data
RUN mkdir -p /root/conf

COPY ravendark.conf /root/conf/ravendark.conf

VOLUME /root/data

# sentinel
ENV ENVIR=docker
RUN apt-get -y install software-properties-common
#RUN add-apt-repository -y ppa:jblgf0/python
#RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install sqlite3 libsqlite3-dev -y
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y;
RUN pip3 install virtualenv;
#RUN cd ~ && \
 # git clone https://github.com/raven-dark/sentinel.git && cd sentinel && mkdir database && \
  #virtualenv ./venv && \
  #./venv/bin/pip install -r requirements.txt && \
  #echo "* * * * *    root    cd /root/sentinel && ./venv/bin/python3 bin/sentinel.py >> /var/log/sentinel.log 2>&1" >> /etc/crontab && \
  #sed -i -e '9iENVIR=docker\' /etc/crontab

RUN mkdir /ravendark

WORKDIR /ravendark

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

#6666 is p2p
EXPOSE 6666

ENTRYPOINT ["./entrypoint.sh"]
