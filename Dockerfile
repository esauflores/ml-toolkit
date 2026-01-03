# ---------- base ----------
FROM debian:12.12-slim@sha256:d5d3f9c23164ea16f31852f95bd5959aad1c5e854332fe00f7b3a20fcc9f635c AS base

LABEL org.opencontainers.image.source="https://github.com/esauflores/ml-toolkit"
LABEL org.opencontainers.image.description="Reproducible ML toolkit using Python 3.12 and uv"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  bash \
  libgomp1 \
  && rm -rf /var/lib/apt/lists/*

# ---------- mise ----------
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV PATH="/mise/shims:$PATH"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -fsSL https://mise.run | sh
COPY src/mise.toml /mise/mise.toml
RUN mise trust /mise/mise.toml && mise install

# ---------- workspace ----------
ENV UV_PROJECT_ENVIRONMENT="/mise/installs/python/latest"
ENV PATH="/mise/installs/python/latest/bin:$PATH"

WORKDIR /workspace

COPY src/Justfile .

CMD ["bash"]

# ---------- cpu ----------
FROM base AS cpu

WORKDIR /workspace

COPY src/cpu-x86_64/pyproject.toml .
COPY src/cpu-x86_64/uv.lock .

RUN just install-all

COPY src/cpu-x86_64/tests/ ./tests/

# ---------- gpu ----------
FROM base AS gpu

WORKDIR /workspace

COPY src/gpu-x86_64/pyproject.toml .
COPY src/gpu-x86_64/uv.lock .

RUN just install-all

COPY src/gpu-x86_64/tests/ ./tests/

