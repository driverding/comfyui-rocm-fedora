FROM fedora:42

# Mirrors
ENV FEDORA_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/fedora"
ENV GITHUB_MIRROR="https://ghfast.top"
ENV PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"
ENV PYTORCH_INDEX_URL="https://download.pytorch.org/whl/rocm6.3"

RUN sed -e "s|^metalink=|#metalink=|g" \
    -e "s|^#baseurl=http://download.example/pub/fedora/linux|baseurl=${FEDORA_MIRROR}|g" \
    -i.bak \
    /etc/yum.repos.d/fedora.repo \
    /etc/yum.repos.d/fedora-updates.repo

RUN dnf update -y
RUN dnf install -y git python3.12 rocm-runtime rocminfo
RUN dnf clean all

WORKDIR /app
RUN git clone ${GITHUB_MIRROR}/https://github.com/comfyanonymous/ComfyUI.git

WORKDIR /app/ComfyUI
RUN python3.12 -m venv .venv

RUN ./.venv/bin/pip config set global.index-url ${PIP_INDEX_URL}
RUN ./.venv/bin/pip install --upgrade pip
RUN ./.venv/bin/pip install torch torchvision torchaudio --index-url ${PYTORCH_INDEX_URL}
RUN ./.venv/bin/pip install -r requirements.txt

ENV HSA_OVERRIDE_GFX_VERSION=10.3.0

EXPOSE 8188
CMD ["/app/ComfyUI/.venv/bin/python", "main.py", "--listen", "0.0.0.0"]
