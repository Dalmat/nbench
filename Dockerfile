FROM ubuntu:18.04

LABEL maintainer="Matthieu Dalstein"

ENV NODE=UNDEFINED

ADD nbench-ubuntu18.04 /opt/bin/nbench-ubuntu18.04
ADD NNET.DAT /opt/var/lib/nbench/NNET.DAT

WORKDIR /opt/var/lib/nbench

RUN apt update && apt upgrade -y && apt install -y sysbench p7zip-full && apt clean

ENTRYPOINT [ "bash", "-c", "if [ \"$NODE\" != \"UNDEFINED\" ]; then echo \"Launching nbench from $NODE\"; fi; /opt/bin/nbench-ubuntu18.04 && 7za b -mmt=1" ]
