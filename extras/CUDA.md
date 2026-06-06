# NVIDIA + CUDA Setup on Arch Linux (DKMS)

Setup for the DKMS NVIDIA driver, so the module rebuilds automatically on kernel updates.

## 1. Check your kernel

```bash
uname -r
```

Pick the matching headers package based on the output:

| Kernel | Headers package |
| ------ | --------------- |
| `*arch*` | `linux-headers` |
| `*zen*`  | `linux-zen-headers` |
| `*lts*`  | `linux-lts-headers` |

## 2. Install build dependencies and kernel headers

```bash
sudo pacman -S --needed base-devel dkms linux-headers
```

- `base-devel` — compilers and tools for building.
- `dkms` — rebuilds kernel modules automatically for new kernels.
- `linux-headers` — needed for DKMS to compile against your kernel.

## 3. Install NVIDIA utilities, CUDA toolkit, and cuDNN

```bash
sudo pacman -S nvidia-utils cuda cudnn
```

- `nvidia-utils` — required for all NVIDIA GPU features.
- `cuda` — NVIDIA CUDA compiler, libraries, and tools.
- `cudnn` — deep learning primitives library (optional, useful for ML/AI).

## 4. Add CUDA to your PATH

Edit your shell config:

```bash
nvim ~/.zshrc
```

Add:

```bash
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH
```

Reload:

```bash
source ~/.zshrc
```

## 5. Verify installation

Check driver status:

```bash
nvidia-smi
```

Check the CUDA compiler:

```bash
nvcc --version
```
