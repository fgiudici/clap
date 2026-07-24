FROM fedora:latest

ARG CLAUDE_VERSION
LABEL claude-code.version="${CLAUDE_VERSION}"

RUN dnf install -y --setopt=install_weak_deps=False \
    ca-certificates \
    git \
    gh \
    golang \
    nodejs npm \
    python3 python3-pip \
    bash \
    curl \
    wget \
    openssh-clients \
    make \
    cmake \
    gcc gcc-c++ \
    jq \
    findutils \
    diffutils \
    patch \
    ripgrep \
    less \
    vim-minimal \
    && dnf clean all

RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_VERSION}

ENV CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

ENV HOME=/home/claude
ENV SHELL=/bin/bash

RUN mkdir -p /home/claude/.claude /workspace && chmod 755 /home/claude

COPY .claude.json /home/claude/.claude.json

WORKDIR /workspace

ENTRYPOINT ["claude"]
