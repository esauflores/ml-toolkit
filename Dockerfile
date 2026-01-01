# ---------- base ----------
FROM debian:12.12-slim@sha256:d5d3f9c23164ea16f31852f95bd5959aad1c5e854332fe00f7b3a20fcc9f635c AS base

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  unzip \
  xz-utils \
  gnupg \
  bash \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# ---------- mise ----------
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV PATH="/mise/shims:$PATH"

RUN curl -fsSL https://mise.run | sh

COPY mise.toml /mise/mise.toml
RUN mise trust /mise/mise.toml \
  && mise install

ENV UV_PROJECT_ENVIRONMENT="/mise/installs/python/latest"
ENV PATH="/mise/installs/python/latest/bin:$PATH"

CMD ["bash"]

# ---------- dev-data ----------
FROM base AS dev-data

LABEL org.opencontainers.image.source="https://github.com/esauflores/ml-toolkit"
LABEL org.opencontainers.image.description="Reproducible ML toolkit using Python 3.12 and uv"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY pyproject.toml uv.lock ./

RUN uv sync --no-install-project --group dev-data

# ---------- dev-ml ----------
FROM base AS dev-ml

LABEL org.opencontainers.image.source="https://github.com/esauflores/ml-toolkit"
LABEL org.opencontainers.image.description="Reproducible ML toolkit using Python 3.12 and uv"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY pyproject.toml uv.lock ./

RUN uv sync --no-install-project --group dev-ml

# ---------- dev-nlp ----------
FROM dev-ml AS dev-nlp

LABEL org.opencontainers.image.source="https://github.com/esauflores/ml-toolkit"
LABEL org.opencontainers.image.description="Reproducible ML toolkit using Python 3.12 and uv"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY pyproject.toml uv.lock ./

RUN uv sync --no-install-project --group dev-nlp

# ---------- dev-serve ----------
FROM base AS dev-serve

LABEL org.opencontainers.image.source="https://github.com/esauflores/ml-toolkit"
LABEL org.opencontainers.image.description="Reproducible ML toolkit using Python 3.12 and uv"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY pyproject.toml uv.lock ./

RUN uv sync --no-install-project  --group dev-serve

