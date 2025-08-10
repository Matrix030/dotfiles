NVIDIA + CUDA Setup on Arch Linux (DKMS Version)
1. Check your kernel version

uname -r

    If it shows arch → use linux-headers

    If it shows zen → use linux-zen-headers

    If it shows lts → use linux-lts-headers

2. Install build dependencies and kernel headers

sudo pacman -S --needed base-devel dkms linux-headers

    base-devel → compilers and tools for building

    dkms → builds kernel modules automatically for new kernels

    linux-headers → needed for DKMS to compile against your kernel

3. Install NVIDIA utilities, CUDA toolkit, and cuDNN

sudo pacman -S nvidia-utils cuda cudnn

    nvidia-utils → required for all NVIDIA GPU features

    cuda → NVIDIA CUDA compiler, libraries, and tools

    cudnn → deep learning primitives library (optional, but useful for ML/AI)

4. Add CUDA to your PATH and library path

Edit your shell configuration:

nano ~/.bashrc    # or ~/.zshrc if using zsh

Add:

export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/lib64:$LD_LIBRARY_PATH

Save, then reload:

source ~/.bashrc   # or source ~/.zshrc

5. Verify installation

Check driver status:

nvidia-smi

Check CUDA compiler:

nvcc --version
