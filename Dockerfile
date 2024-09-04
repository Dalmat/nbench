FROM golang:1.18 as go-builder

ADD http://www.math.utah.edu/~mayer/linux/nbench-byte-2.2.3.tar.gz /root/
RUN cd /root && tar xzf /root/nbench-byte-2.2.3.tar.gz
RUN cd /root/nbench-byte-2.2.3/ && make
RUN git clone https://github.com/AmadeusITGroup/cpubench1A
RUN cd cpubench1A && make build

FROM ubuntu:24.04
LABEL maintainer="Matthieu Dalstein <github@dalmat.net>"
ENV NODE=UNDEFINED
WORKDIR /opt/var/lib/nbench

ADD video.MP4 /opt/ffmpeg/

RUN apt update && apt upgrade -y && apt install -y sysbench p7zip ffmpeg && apt clean

COPY --from=go-builder /root/nbench-byte-2.2.3/nbench /opt/bin/
COPY --from=go-builder /root/nbench-byte-2.2.3//NNET.DAT /opt/var/lib/nbench/NNET.DAT

COPY --from=go-builder /go/cpubench1A/cpubench1a /opt/bin/

ADD bench.sh /opt/bin/bench.sh
ENTRYPOINT [ "/opt/bin/bench.sh" ]