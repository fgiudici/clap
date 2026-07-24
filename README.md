# clap - Claude Agent in Podman

Run [Claude Code](https://docs.anthropic.com/en/docs/claude-code) in a Podman container with Go, Python, Node.js, and common dev tools on a Fedora base.

## Quick start

```sh
make build          # build the container image
make install        # install clap to ~/.local/bin
make setup-env      # copy env.example to ~/.clap/env
# edit ~/.clap/env and uncomment the variables you need
```

Then, from any project directory:

```sh
clap
```

## Build

```sh
make
```

To pin a specific Claude Code version or image tag:

```sh
make CLAUDE_VERSION=0.2.20
make IMAGE_TAG=v2
```

## Usage

```sh
clap                            # interactive session
clap -p "explain this codebase" # one-shot prompt
clap --auto                     # non-interactive, auto-accept permissions
```

The wrapper mounts:
- `~/.clap/claude` config directory (isolated from a native Claude Code install)
- Current directory as `/workspace`
- `~/.config/gcloud` credentials (read-only, only when `ANTHROPIC_VERTEX_PROJECT_ID` is set)

It runs as your host UID/GID so file ownership is preserved.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `CLAUDE_CODE_USE_VERTEX` | _(unset)_ | Set to `1` to use Vertex AI as the backend |
| `CLOUD_ML_REGION` | _(unset)_ | Vertex AI region (e.g. `global`) |
| `ANTHROPIC_VERTEX_PROJECT_ID` | _(unset)_ | GCP project ID for Vertex AI |
| `CLAUDE_IMAGE` | `clap:latest` | Container image name/tag |
| `GH_TOKEN` | _(unset)_ | GitHub personal access token for `gh` CLI |

Override via environment:

```sh
CLAUDE_IMAGE=clap:v2 clap
```

### Environment file

If `~/.clap/env` exists, it is sourced before launching the container. Use it to
set variables without exporting them in your shell profile.

To get started, run `make setup-env` or copy manually:

```sh
mkdir -p ~/.clap
cp env.example ~/.clap/env
chmod 600 ~/.clap/env
```

### Vertex AI setup

To use Claude via Vertex AI, install and authenticate `gcloud` on the host:

```sh
gcloud auth application-default login
gcloud auth application-default set-quota-project <your-project-id>
```

Then enable Vertex in `~/.clap/env`:

```sh
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=global
export ANTHROPIC_VERTEX_PROJECT_ID=your-gcp-project-id
```

## Prerequisites

- `podman`
- `~/.local/bin` in your `$PATH` (for `make install`)

## What's inside

- Fedora base image
- Claude Code (via npm)
- Go, Python 3, Node.js / npm
- Build tools: make, cmake, gcc/g++
- Git, gh, openssh-clients
- CLI utilities: bash, curl, wget, jq, ripgrep, less, vim
- findutils, diffutils, patch
