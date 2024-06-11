FROM ubuntu:latest
RUN apt-get update

RUN apt-get upgrade -y
RUN apt-get install -y gcc binutils make perl liblzma-dev mtools genisoimage syslinux isolinux git gcc-aarch64-linux-gnu

RUN mkdir -p /build

ADD ipxe /build/ipxe_amd64
ADD ipxe /build/ipxe_aarch64
ADD build_targets /build
ADD compile.sh /build
ADD customize.sh /build

WORKDIR /build

RUN ./compile.sh

CMD ./customize.sh
