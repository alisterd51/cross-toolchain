FROM debian:12.6@sha256:1dc55ed6871771d4df68d393ed08d1ed9361c577cfeb903cd684a182e8a3e3ae

RUN apt update && apt install -y \
    mtools \
    wget \
    xz-utils \
    clang \
    make \
    texinfo \
    curl \
    xorriso \
    grub2 \
    git \
    qemu-system

ENV BINUTILS_VER=2.42

RUN export TARGET=i686-elf && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.xz && \
    tar xf binutils-${BINUTILS_VER}.tar.xz && \
    cd binutils-${BINUTILS_VER} && \
    mkdir build && \
    cd build && \
    ../configure --target=$TARGET --with-sysroot --disable-nls --disable-werror && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf binutils-${BINUTILS_VER}.tar.xz binutils-${BINUTILS_VER}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:$PATH"

RUN rustup toolchain install nightly && \
    rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu
