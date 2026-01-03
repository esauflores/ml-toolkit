REGISTRY := "ghcr.io/esauflores/ml-toolkit"
VERSION  := "1.1"
TARGETS  := "cpu gpu"

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

# Test Docker images 
test *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "🧪 Testing $t"
    case $t in
      cpu|gpu)
        docker run --rm {{REGISTRY}}:$t \
          bash -c "
            set -ex
            python --version 
            uv --version
            just test
          "
        ;;
      *)
        echo "❌ Unknown target: $t"
        exit 1
        ;;
    esac
    echo "✅ $t passed"
  done

# Clean Docker images
clean *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    docker rmi {{REGISTRY}}:$t || true
    docker rmi {{REGISTRY}}:{{VERSION}}-$t || true
  done
  docker image prune -f

# Build, test and push Docker images (all or selected targets)
release *targets='':
  #!/usr/bin/env bash
  set -e
  just build base
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    just build $t
    just test $t 
    just push $t
    just clean $t
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

