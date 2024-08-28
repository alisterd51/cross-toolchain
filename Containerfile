FROM debian:12.6@sha256:aadf411dc9ed5199bc7dab48b3e6ce18f8bbee4f170127f5ff1b75cd8035eb36

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    mtools \
    xz-utils \
    clang \
    make \
    texinfo \
    curl \
    ca-certificates \
    xorriso \
    grub2 \
    git \
    qemu-system \
    qemu-system-gui && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV BINUTILS_VER=2.43
ENV TARGET=i686-elf

WORKDIR /usr/src/app
RUN curl -O https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.xz && \
    tar xf binutils-${BINUTILS_VER}.tar.xz
WORKDIR /usr/src/app/binutils-${BINUTILS_VER}/build
RUN ../configure --target=${TARGET} --with-sysroot --disable-nls --disable-werror && \
    make && \
    make install
WORKDIR /usr/src/app
RUN rm -rf binutils-${BINUTILS_VER}.tar.xz binutils-${BINUTILS_VER}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:$PATH"

RUN rustup toolchain install nightly && \
    rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu