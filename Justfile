REGISTRY := "ghcr.io/esauflores/ml-toolkit"
VERSION  := "1.0"
TARGETS  := "dev-data dev-ml dev-nlp dev-serve"

default:
  @just --list

# Build Docker images (all or selected targets)
build *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "🔨 Building $t"
    docker build --target $t -t {{REGISTRY}}:$t -t {{REGISTRY}}:{{VERSION}}-$t .
  done

# Push Docker images to registry (all or selected images)
push *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "📦 Pushing $t"
    docker push {{REGISTRY}}:$t
    docker push {{REGISTRY}}:{{VERSION}}-$t
  done

# Build and push Docker images (all or selected targets)
release *targets='': (build targets) (push targets)

# Test Docker images 
test *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "🧪 Testing $t"
    case $t in
      dev-data)
        docker run --rm {{REGISTRY}}:$t python -c "import pandas; print(f'pandas {pandas.__version__}')"
        ;;
      dev-ml)
        docker run --rm {{REGISTRY}}:$t python -c "import torch; print(f'torch {torch.__version__}')"
        ;;
      dev-nlp)
        docker run --rm {{REGISTRY}}:$t python -c "import torch; print(f'torch {torch.__version__}')"
        ;;
      dev-serve)
        docker run --rm {{REGISTRY}}:$t python -c "from fastapi import FastAPI; print('fastapi works')"
        ;;
    esac
    echo "✅ $t passed"
  done

# check updates for tools
mise-check-updates:
  #!/usr/bin/env bash
  set -e
  echo "🔎 Updates within pinned minor version"
  mise outdated
  echo "🚨 Newer versions available"
  mise outdated -l

# Login to container registry 
login: 
  docker login ghcr.io

