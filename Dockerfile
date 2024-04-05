FROM debian:12.5@sha256:e97ee92bf1e11a2de654e9f3da827d8dce32b54e0490ac83bfc65c8706568116

RUN apt update && apt install -y \
    mtools \
    wget \
    xz-utils \
    clang \
    make \
    texinfo \
    curl \
    xorriso \
    grub2

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
