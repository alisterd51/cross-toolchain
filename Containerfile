FROM debian:12.6@sha256:45f2e735295654f13e3be10da2a6892c708f71a71be845818f6058982761a6d3

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
    qemu-system && \
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
