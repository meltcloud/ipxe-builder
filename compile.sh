#!/bin/bash
set -euo pipefail

if [ ! -f build_targets ]; then
  exit 1
fi

. build_targets

# TODO Workaround - Else the build fails because it wants a git repository
# to determine MAJOR_VERSION based on the last tag in the Makefile but our
# source directory is a submodule ripped from it's parent git repo.
fix_git() {
  cd $1
  rm .git
  git init
  git config --global user.email "you@example.com"
  git add .
  git commit -m'Fake'
  git tag v0.00.0-000-0000000
  cd -
}

fix_git ipxe_amd64
fix_git ipxe_aarch64

cd ipxe_amd64/src
make -j 4 ${TARGETS_AMD64}
cd -

cd ipxe_aarch64/src
make -j 4 ${TARGETS_AARCH64} CROSS=aarch64-linux-gnu-
cd -
