# ML Toolkit – Reproducible ML Environment

A reproducible, Docker-based **machine learning environment** built with **mise**, **uv**, and **just**.

This project provides **deterministic CPU and GPU ML environments** that can be built, tested, and used consistently across local machines and CI systems — without relying on host-installed Python, CUDA, or ML tooling.

The goal is simple: **reproducible ML environments, zero local setup pain**.

---

## ✨ What This Project Is

- A **tooling-focused ML environment**
- Designed for **experimentation, validation, and CI**
- CPU and GPU variants with identical structure
- Deterministic dependency resolution and runtime behavior

This project is **not an application**, **not a model**, and **not a training pipeline**.

---

## ❌ What This Project Is Not

- ❌ Not application source code
- ❌ Not a Python package meant to be imported
- ❌ Not a production inference image
- ❌ Not a framework or library

It exists to provide a **known-good ML runtime**.

---

## 🧠 Design Principles

- **Reproducibility first**
- **Environment > application**
- **Explicit over implicit**
- **CI parity with local usage**
- **Minimal OS dependencies**

---

## 📁 Project Structure

```text
.
├── Dockerfile
├── Justfile
└── src/
├───  mise.toml
├───  cpu-x86_64/
│ ├── pyproject.toml
│ ├── uv.lock
│ ├── Justfile
│ └── tests/
└── gpu-x86_64/
├── pyproject.toml
├── uv.lock
├── Justfile
└── tests/
```

### Directory responsibilities

| Path                   | Purpose                                |
| ---------------------- | -------------------------------------- |
| `mise.toml`            | Toolchain versions (Python, uv, etc.)  |
| `Dockerfile`           | Multi-stage CPU/GPU environment builds |
| `src/*/pyproject.toml` | ML dependency specification            |
| `src/*/uv.lock`        | Fully locked dependency graph          |
| `src/*/Justfile`       | Environment commands (`just test`)     |
| `src/*/tests/`         | Environment validation tests           |

---

## 🧰 Tooling Stack

- **Docker** – environment isolation
- **mise** – toolchain version management
- **uv** – fast, deterministic dependency resolution
- **just** – consistent workflows
- **pytest** – environment validation

---

## 🧪 Environment Validation

Tests in this project are **environment-level tests**, not application tests.

They validate that:

- Python is installed correctly
- Native runtime libraries are present (e.g. OpenMP)
- ML libraries import successfully
- CPU/GPU capabilities are detected correctly

## 🏗️ Build Environments

Build CPU or GPU environments using just:

```bash
just build cpu
just build gpu
```

Build everything:

```bash
just build
```

## 🧪 Test Environments

Run environment validation tests

```bash
just test cpu
just test gpu
```

Or test all environments:

```bash
just test
```

Tests are always run inside the container, never on the host.

## 🔁 Reproducibility Guarantees

- Tool versions pinned via mise.toml
- Python dependencies locked via uv.lock
- No reliance on host-installed Python or ML libraries
- Identical behavior in CI and local Docker runs

## 🔐 OS & Native Dependencies

Minimal OS packages are installed explicitly to support ML runtimes:

- libgomp1 for OpenMP (LightGBM, XGBoost, etc.)
- No unnecessary system tooling

Native dependencies are treated as part of the environment contract, not accidental side effects.

## 📌 Use Cases

- ML experimentation environments
- CI validation of ML stacks
- CPU/GPU parity testing
- Platform or infra ML tooling
- Reproducible research environments

## 🛠️ Requirements

- Docker (BuildKit enabled)
- just (recommended)
- Internet access during image build

## 📄 License

This project is licensed under the MIT License.
