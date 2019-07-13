FROM darkmattercoder/qt-build:5.11.2 AS builder

ARG SSL_KEYSTORE_PASSWORD
USER root

RUN apt-get update \
  && apt-get install -y wget tar

ENV XVERSION="6.47"
ENV XSRCTAR="xflr5_v${XVERSION}_src.tar.gz"

RUN cd /opt \
  && wget https://sourceforge.net/projects/xflr5/files/${XVERSION}/${XSRCTAR} \
  && tar -xzvf ${XSRCTAR} \
  && mkdir -p /opt/build \
  && cd /opt/build \
  && qmake /opt/xflr5 \
  && make -j16

FROM debian:buster-slim AS runtime

RUN apt-get update \
  && apt-get install -y \
    libqt5opengl5 \
    libqt5xml5 \
    libgl1-mesa-glx \
    qt5-image-formats-plugins \
    qtwayland5

COPY --from=builder  /opt/build/xflr5-engine/libxflr5-engine.s* /opt/build/XFoil-lib/libXFoil.s* /usr/lib/
COPY --from=builder  /opt/build/xflr5-gui/xflr5 /usr/bin
RUN chmod ugo+x /usr/bin/xflr5

VOLUME /xflr5
WORKDIR /xflr5

ENV XDG_RUNTIME_DIR=/xflr5

CMD xflr5
