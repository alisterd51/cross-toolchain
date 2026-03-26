FROM debian:trixie-20260316@sha256:55a15a112b42be10bfc8092fcc40b6748dc236f7ef46a358d9392b339e9d60e8

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    clang \
    mtools \
    xz-utils \
    make \
    curl \
    ca-certificates \
    xorriso \
    grub2 \
    git \
    qemu-system \
    qemu-system-gui && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:$PATH"

RUN rustup toolchain install nightly && \
    rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu
