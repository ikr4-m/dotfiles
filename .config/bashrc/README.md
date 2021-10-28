Hotfix/addition configuration for bashrc.

## How to install
1. Copy this folder to `~/`.
2. Open `.bashrc` or `.zshrc` or whatever do you use.
3. Source file that you want with this code
```bash
source ~/bashrc/file.d
```
4. Close your terminal, and done

## Notes (Proton)
- The alias for NVIDIA Prime is:
```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia
```

- Sometimes, Unity based game can fixed with
```sh
# winhttp, native first than builtin
WINEDLLOVERRIDES="winhttp=n,b"
```
