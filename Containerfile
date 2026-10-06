FROM debian:13@sha256:913f6706df59a68922d1dd08f78c2476560a8d367897200a6005b00e5f67c2d5

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
