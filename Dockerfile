FROM --platform=linux/amd64 ubuntu:latest
RUN apt-get update

RUN apt-get upgrade -y
RUN apt-get install -y gcc binutils make perl liblzma-dev mtools genisoimage syslinux isolinux git gcc-aarch64-linux-gnu openssl curl qemu-utils

RUN mkdir -p /build

RUN set -xe \
    && git clone https://github.com/ipxe/ipxe.git /build/ipxe

COPY config /build/ipxe/src/config

RUN cp -rp /build/ipxe /build/ipxe_amd64
RUN cp -rp /build/ipxe /build/ipxe_aarch64


ADD build_targets /build
ADD compile.sh /build
ADD customize.sh /build
ADD generate_artifacts.sh /build

WORKDIR /build

RUN ./compile.sh 

CMD ./customize.sh
