#!/bin/bash


IPXE_CONFIG=/input
OUTPUT=/output

. ${PWD}/build_targets

if [ ! -d ${OUTPUT} ]; then
	mkdir ${OUTPUT}
fi

if [ -f ${IPXE_CONFIG}/script/embed.ipxe ]; then
	EMBED=${IPXE_CONFIG}/script/embed.ipxe
else
	echo "Error: no embedded ipxe script provided under ${IPXE_CONFIG}/script/embed.ipxe"
	exit 1
fi
if [ -f ${IPXE_CONFIG}/tls/tls.crt ]; then
	CERT=${IPXE_CONFIG}/tls/tls.crt
else
	echo "Error: no client certificate provided under ${IPXE_CONFIG}/tls/tls.crt"
	exit 1
fi
if [ -f ${IPXE_CONFIG}/tls/tls.key ]; then
	PRIVKEY=${IPXE_CONFIG}/tls/tls.key
else
	echo "Error: no client private key provided under ${IPXE_CONFIG}/tls/tls.key"
	exit 1
fi


MAKE_PARAMS="EMBED=${EMBED} CERT=${CERT} PRIVKEY=${PRIVKEY}"

if [ -f ${IPXE_CONFIG}/ca.pem ]; then
	MAKE_PARAMS="${MAKE_PARAMS} TRUST=${IPXE_CONFIG}/ca.pem"
fi

BUILDS="bin/undionly.kpxe bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi"

build_amd64() {
  pushd ${PWD}/ipxe_amd64/src
  make ${TARGETS_AMD64} ${MAKE_PARAMS}
  popd
}

build_aarch64() {
  pushd ${PWD}/ipxe_aarch64/src
  make  ${TARGETS_AARCH64} CROSS=aarch64-linux-gnu- ${MAKE_PARAMS}
  popd
}

build_iso() {
	#todo
  target="${OUTPUT}/ipxe.iso"
  ${PWD}/ipxe_amd64/src/util/genfsimg -o $target ${PWD}/ipxe_amd64/src/bin/ipxe.lkrn ${PWD}/ipxe_amd64/src/bin-x86_64-efi/ipxe.efi ${PWD}/ipxe_aarch64/src/bin-arm64-efi/ipxe.efi
}

move_artifacts() {
  for target in ${TARGETS_AMD64}; do
	  mv ${PWD}/ipxe_amd64/src/$target ${OUTPUT}
  done
  for target in ${TARGETS_AARCH64}; do
	  mv ${PWD}/ipxe_aarch64/src/$target ${OUTPUT}
  done
}

upload_artifact() {
    ARTIFACT=$1
    FILENAME=$2

    echo "uploading ${FILENAME} the quick and dirty way"
    BYTE_SIZE=$(stat --printf="%s" ${OUTPUT}/${FILENAME})
    CHECKSUM=$(openssl dgst -md5 -binary ${OUTPUT}/${FILENAME} | base64)

    URL=$(cat /input/upload_urls/.upload_url_${ARTIFACT})
    URL="${URL}?byte_size=${BYTE_SIZE}&checksum=${CHECKSUM}"

    DIRECT_UPLOAD=$(curl ${URL})
    DIRECT_UPLOAD="${DIRECT_UPLOAD} --data-binary @${OUTPUT}/${FILENAME}"
    eval ${DIRECT_UPLOAD}
}

build_amd64
build_aarch64
build_iso
move_artifacts
upload_artifact "iso" "ipxe.iso"
upload_artifact "pxe" "undionly.kpxe"
upload_artifact "efi" "ipxe.efi"
