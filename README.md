# ipxe-builder

container image with pre-complied ipxe roms (undiomly.kpxe, amd64-ipxe.efi, aarch64-ipxe.efi, ipxe.iso) 

## getting started

build image

```
# # apply patch to ipxe submodule enabling crypto / https
# cd ipxe; git apply ../patches/crypto.patch
# docker build . -t ipxe-builder

```
prepare customization inputs (client cert, key and embedded script).
filenames need to be respected:
- cert.pem
- key.pem
- embed.ipxe

```
# mkdir ~/ipxe_inputs
# mkdir ~/ipxe_artifacts
# copy cert.pem key.pem embed.ipxe ~/ipxe_inputs 

```
customize ipxe rom

```
# docker run --rm -v ~/ipxe_inputs:/input -v ~/ipxe_artifacts:/output ipxe-builder 
```
