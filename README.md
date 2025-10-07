# Docker images for SimOS
This repository contains Dockerfiles for creating containerized environments for SimOS, a simulation software. The images are designed to be lightweight and easy to use, with different variants for CPU, MKL, and CUDA support. Additionally, there are overlay images that add Jupyter Notebook support for interactive computing. You will need to have Docker installed on your system to use these images. 

Install from Docker Hub using (pick variant as needed):
```bash
# Base images
docker pull kherb27/simos:cpu
docker pull kherb27/simos:mkl
docker pull kherb27/simos:cuda
# Jupyter overlays
docker pull kherb27/simos:cpu-jupyter
docker pull kherb27/simos:mkl-jupyter
docker pull kherb27/simos:cuda-jupyter
```

To run the images, use
```bash
# Base images
docker run --rm -it kherb27/simos:cpu python
docker run --rm -it kherb27/simos:mkl python
docker run --rm -it --gpus all kherb27/simos:cuda python
# Jupyter overlays
docker run --rm -it -p 8888:8888 kherb27/simos:cpu-jupyter
docker run --rm -it -p 8888:8888 kherb27/simos:mkl-jupyter
docker run --rm -it -p 8888:8888 --gpus all kherb27/simos:cuda-jupyter
```
If you want a persistant workspace, mount a local directory as `/workspace`, e.g.
```bash
docker run --rm -it -p 8888:8888 -v ./persistent:/workspace/persistent kherb27/simos:cpu-jupyter
docker run --rm -it -p 8888:8888 -v ./persistent:/workspace/persistent kherb27/simos:mkl-jupyter
docker run --rm -it -p 8888:8888 -v ./persistent:/workspace/persistent --gpus all kherb27/simos:cuda-jupyter
```

## CI/CD (GitHub Actions → GHCR)

This repo automatically builds and publishes Docker images to the GitHub Container Registry (GHCR). These can be considered as nighly builds, as they are built on every push to the default branch, and on every git tag. We will release official versions of SimOS separately on Docker Hub.

Published image names:
- `ghcr.io/spinsimulation/simos:cpu`
- `ghcr.io/spinsimulation/simos:mkl`
- `ghcr.io/spinsimulation/simos:cuda`
- `ghcr.io/spinsimulation/simos:cpu-jupyter`
- `ghcr.io/spinsimulation/simos:mkl-jupyter`
- `ghcr.io/spinsimulation/simos:cuda-jupyter`

Tags:
- On the default branch:
  - `cpu`, `mkl`, `cuda`, `cpu-jupyter`, `mkl-jupyter`, `cuda-jupyter`
- On a git tag (e.g., `v1.2.3`):
  - `v1.2.3-cpu`, `v1.2.3-mkl`, `v1.2.3-cuda`, etc.
- Always:
  - `sha-<short>-cpu`, `sha-<short>-mkl`, `sha-<short>-cuda`, etc.

Install using

```bash
# Base images
docker pull ghcr.io/spinsimulation/simos:cpu
docker pull ghcr.io/spinsimulation/simos:mkl
docker pull ghcr.io/spinsimulation/simos:cuda

# Jupyter overlays
docker pull ghcr.io/spinsimulation/simos:cpu-jupyter
docker pull ghcr.io/spinsimulation/simos:mkl-jupyter
docker pull ghcr.io/spinsimulation/simos:cuda-jupyter
```


## Developers
Build all Docker images using
```bash
docker build -t simos:cpu -f dockerfiles/Dockerfile.cpu  --load .
docker build -t simos:mkl -f dockerfiles/Dockerfile.mkl --load .
docker build -t simos:cuda -f dockerfiles/Dockerfile.cuda --load .
```

To run the images, use
```bash
docker run --rm -it simos:cpu python
docker run --rm -it simos:mkl python
docker run --rm -it --gpus all simos:cuda python
```

For the Jupyter overlay images, build using
```bash
docker buildx build -f dockerfiles\Dockerfile.cpu-jupyter -t simos:cpu-jupyter --load .
docker buildx build -f dockerfiles\Dockerfile.mkl-jupyter -t simos:mkl-jupyter --load .
docker buildx build -f dockerfiles\Dockerfile.cuda-jupyter -t simos:cuda-jupyter --load .
```
Run using
```bash
docker run --rm -it -p 8888:8888 simos:cpu-jupyter
docker run --rm -it -p 8888:8888 simos:mkl-jupyter
docker run --rm -it -p 8888:8888 --gpus all simos:cuda-jupyter
```

If you want a persistant workspace, mount a local directory, e.g.
```bash
docker run --rm -it -p 8888:8888 -v ./persistent:/workspace/persistent simos:cpu-jupyter
docker run --rm -it -p 8888:8888 -v ./persistent:/workspace/persistent simos:mkl-jupyter
docker run --rm -it -p 8888:8888 -v ./persistent:/workspace/persistent --gpus all simos:cuda-jupyter
```
