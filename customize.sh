#!/bin/bash

IPXE_CONFIG=/input
OUTPUT=/output

. ${PWD}/build_targets

if [ -f ${IPXE_CONFIG}/embed.ipxe ]; then
	EMBED=${IPXE_CONFIG}/embed.ipxe
else
	echo "Error: no embedded ipxe script provided under ${IPXE_CONFIG}/embed.ipxe"
	exit 1
fi
if [ -f ${IPXE_CONFIG}/cert.pem ]; then
	CERT=${IPXE_CONFIG}/cert.pem
else
	echo "Error: no client certificate provided under ${IPXE_CONFIG}/cert.pem"
	exit 1
fi
if [ -f ${IPXE_CONFIG}/key.pem ]; then
	PRIVKEY=${IPXE_CONFIG}/key.pem
else
	echo "Error: no client private key provided under ${IPXE_CONFIG}/key.pem"
	exit 1
fi

MAKE_PARAMS="EMBED=${EMBED} CERT=${CERT} PRIVKEY=${PRIVKEY}"

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

build_amd64
build_aarch64
build_iso
move_artifacts
