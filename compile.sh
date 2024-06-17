#!/bin/bash
set -euo pipefail

if [ ! -f build_targets ]; then
  exit 1
fi

. build_targets

cd ipxe_amd64/src
make -j $(nproc) ${TARGETS_AMD64}
cd -

cd ipxe_aarch64/src
make -j $(nproc) ${TARGETS_AARCH64} CROSS=aarch64-linux-gnu-
cd -
