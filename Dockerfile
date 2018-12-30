FROM alpine:3.8

MAINTAINER Dieter Bocklandt <dieterbocklandt@gmail.com>

ARG SABNZBD_VERSION=2.3.6
ARG PAR2CMDLINE_VERSION=0.8.0
ARG YENC_VERSION=0.4.0

ADD sabnzbd.sh /sabnzbd.sh
RUN chmod 755 /sabnzbd.sh

RUN \
  addgroup -S sabnzbd -g 666 && \
  adduser -S sabnzbd -G sabnzbd -u 666 -h /datadir -s /bin/sh && \
  export BUILD_PACKAGES="gcc autoconf automake curl g++ make python-dev libressl-dev libffi-dev" && \
  export RUNTIME_PACKAGES="unrar unzip p7zip py-pip libressl libffi ca-certificates libgomp" && \
  apk add --update $BUILD_PACKAGES $RUNTIME_PACKAGES && \
  curl -SL -o /tmp/sabnzbd.tar.gz https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz && \
  tar xzf /tmp/sabnzbd.tar.gz -C /tmp && \
  mkdir -p /opt && \
  mv /tmp/SABnzbd-* /opt/sabnzbd && \
  chown -R sabnzbd: /opt/sabnzbd && \
  curl -SL -o /tmp/par2cmdline.tar.gz https://github.com/Parchive/par2cmdline/releases/download/v0.8.0/par2cmdline-${PAR2CMDLINE_VERSION}.tar.gz && \
  tar xzf /tmp/par2cmdline.tar.gz -C /tmp && \
  cd /tmp/par2cmdline-* && \
  aclocal && automake --add-missing && autoconf && ./configure && make && make install && \
  pip install --upgrade pip && \
  pip install cheetah configobj feedparser cryptography sabyenc && \
  curl -o /tmp/yenc-${YENC_VERSION}.tar.gz http://www.golug.it/pub/yenc/yenc-${YENC_VERSION}.tar.gz && \
  tar xzf /tmp/yenc-${YENC_VERSION}.tar.gz -C /tmp && \
  cd /tmp/yenc-${YENC_VERSION} && \
  python setup.py build && python setup.py install && \
  cd / && \
  apk del $BUILD_PACKAGES && \
  rm -rf /var/cache/apk/* /tmp/par2cmdline /root/pip.py /tmp/yenc-${YENC_VERSION}.tar.gz /tmp/yenc-${YENC_VERSION}

EXPOSE 8080

WORKDIR /opt/sabnzbd

CMD ["/sabnzbd.sh"]