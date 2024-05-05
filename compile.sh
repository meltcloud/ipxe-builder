#!/bin/bash 
if [ -f build_targets ]; then
  . ${PWD}/build_targets
else
  exit 1
fi
(cd ${PWD}/ipxe_amd64/src && make -j 4 ${TARGETS_AMD64})

(cd ${PWD}/ipxe_aarch64/src && make -j 4 ${TARGETS_AARCH64} CROSS=aarch64-linux-gnu-)
