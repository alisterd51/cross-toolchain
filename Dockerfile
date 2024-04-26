FROM debian:12.5@sha256:1aadfee8d292f64b045adb830f8a58bfacc15789ae5f489a0fedcd517a862cb9

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
