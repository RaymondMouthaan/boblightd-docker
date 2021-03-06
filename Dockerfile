ARG S6_ARCH
FROM arm32v6/alpine:3.8

# Define ARGs again to make them available after FROM
ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_REF

USER root

# Basic build-time metadata as defined at http://label-schema.org
LABEL org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.dockerfile="Dockerfile" \
    org.label-schema.license="GNU" \
    org.label-schema.name="boblightd" \
    org.label-schema.version=${BUILD_VERSION} \
    org.label-schema.description="" \
    org.label-schema.url="" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="" \
    maintainer="Raymond M Mouthaan <raymondmmouthaan@gmail.com>"

COPY qemu/qemu-arm-static /usr/bin/

RUN set -x \
  && apk update \
  && apk add --no-cache automake make g++ autoconf libtool libusb portaudio \
  && mkdir tmp/boblightd

COPY . tmp/boblightd

RUN cd tmp/boblightd \
  && ./autogen.sh \
  && ./configure --without-x11 --prefix=/usr \
  && make \
  && make install

#WORKDIR /homebridge
#VOLUME /homebridge
