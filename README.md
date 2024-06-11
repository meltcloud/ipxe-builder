# ipxe-builder

Container image with pre-complied ipxe roms (undionly.kpxe, amd64-ipxe.efi, aarch64-ipxe.efi, ipxe.iso)

## Getting started

```bash
git submodule update --init --recursive
```

build image

```bash
# apply patch to ipxe submodule enabling crypto / https
(cd ipxe && git apply ../patches/crypto.patch)
docker build . -t ipxe-builder

prepare customization inputs (client cert, key and embedded script).
filenames need to be respected:

- cert.pem
- key.pem
- embed.ipxe

```bash
foundry=<path to your foundry repo>
cp $foundry/test_ca/client.crt inputs/cert.pem
cp $foundry/test_ca/client.key inputs/key.pem
cp $foundry/test_ipxe_config/embed.ipxe inputs/
```

customize ipxe rom

```bash
docker run --rm -v ./inputs:/input -v ./artifacts:/output ipxe-builder
```
