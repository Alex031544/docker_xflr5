FROM darkmattercoder/qt-build:5.11.2 as install

ARG SSL_KEYSTORE_PASSWORD
USER root

RUN apt-get update
RUN apt-get install -y wget tar

ENV XVERSION="6.47"
ENV XSRCTAR="xflr5_v${XVERSION}_src.tar.gz"

WORKDIR /opt
RUN wget https://sourceforge.net/projects/xflr5/files/${XVERSION}/${XSRCTAR}
RUN tar -xzvf ${XSRCTAR}
RUN qmake /opt/xflr5 && make -j8

FROM debian:buster as runtime

RUN apt-get update && \
  apt-get install -y \
    libqt5opengl5 \
    libqt5xml5 \
    libgl1-mesa-glx

COPY --from=install /opt/xflr5-engine/libxflr5-engine.so /usr/lib/
COPY --from=install /opt/xflr5-engine/libxflr5-engine.so.1 /usr/lib/
COPY --from=install /opt/xflr5-engine/libxflr5-engine.so.1.0 /usr/lib/
COPY --from=install /opt/xflr5-engine/libxflr5-engine.so.1.0.0 /usr/lib/

COPY --from=install /opt/XFoil-lib/libXFoil.so /usr/lib/
COPY --from=install /opt/XFoil-lib/libXFoil.so.1 /usr/lib/
COPY --from=install /opt/XFoil-lib/libXFoil.so.1.0 /usr/lib/
COPY --from=install /opt/XFoil-lib/libXFoil.so.1.0.0 /usr/lib/

COPY --from=install /opt/xflr5-gui/xflr5 /usr/bin
RUN chmod ugo+x /usr/bin/xflr5

VOLUME /xflr5
WORKDIR /xflr5

ENV XDG_RUNTIME_DIR=/xflr5

CMD xflr5
