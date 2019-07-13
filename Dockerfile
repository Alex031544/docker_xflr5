FROM darkmattercoder/qt-build:5.11.2 AS builder

ARG SSL_KEYSTORE_PASSWORD
USER root

RUN apt-get update \
  && apt-get install -y wget tar

ENV XVERSION="6.47"
ENV XSRCTAR="xflr5_v${XVERSION}_src.tar.gz"

WORKDIR /opt
RUN wget https://sourceforge.net/projects/xflr5/files/${XVERSION}/${XSRCTAR} \
  && tar -xzvf ${XSRCTAR} \
  && mkdir build \
  && cd build \
  && qmake /opt/xflr5 \
  && make -j8 \
  && ls


FROM debian:buster AS runtime

RUN apt-get update \
  && apt-get install -y \
    libqt5opengl5 \
    libqt5xml5 \
    libgl1-mesa-glx

COPY --from=builder  /opt/xflr5-engine/libxflr5-engine.so.1 /usr/lib/
COPY --from=builder  /opt/xflr5-engine/libxflr5-engine.so.1.0 /usr/lib/
COPY --from=builder  /opt/xflr5-engine/libxflr5-engine.so.1.0.0 /usr/lib/

COPY --from=builder  /opt/xflr5/XFoil-lib/libXFoil.so /usr/lib/
COPY --from=builder  /opt/xflr5/XFoil-lib/libXFoil.so.1 /usr/lib/
COPY --from=builder  /opt/xflr5/XFoil-lib/libXFoil.so.1.0 /usr/lib/
COPY --from=builder  /opt/xflr5/XFoil-lib/libXFoil.so.1.0.0 /usr/lib/

COPY --from=builder  /opt/xflr5/xflr5-gui/xflr5 /usr/bin
RUN chmod ugo+x /usr/bin/xflr5

VOLUME /xflr5
WORKDIR /xflr5

ENV XDG_RUNTIME_DIR=/xflr5

CMD xflr5
