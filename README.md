# comfyui-rocm-fedora

A dockerfile for ComfyUI ROCm deployment with Fedora image.

This is the minimal setup to get ComfyUI booting.

## Usage

1. Change the mirror urls to the fastest in your region. The default is for in China.

2. Change HSA_OVERRIDE_GFX_VERSION to your GPU.

3. Build the image.

4. Run it with parameters: --device=/dev/kfd --device=/dev/dri --group-add video --group-add render -p 8188:8188
