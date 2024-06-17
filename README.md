# ipxe-builder

Container image with pre-complied ipxe roms (undionly.kpxe, amd64-ipxe.efi, aarch64-ipxe.efi, ipxe.iso)

## Getting started

build image

```bash
docker build . -t ipxe-builder
```

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

You might need to remove the passphrase (at least Sevä does on linux...) to
prevent `Could not read private key from /input/key.pem` when customizing.

```bash
openssl rsa -in inputs/key.pem -out inputs/key.pem.unprotected
mv inputs/key.pem{.unprotected,}
```

customize ipxe rom

```bash
docker run --rm -v ./inputs:/input -v ./artifacts:/output ipxe-builder
```
