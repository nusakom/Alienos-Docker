# =========================================================
# Dockerfile for Alien / ArceOS Development Environment
# =========================================================
FROM ubuntu:22.04

# -------------------------
# 基础环境变量
# -------------------------
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# -------------------------
# 基础依赖
# -------------------------
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    ca-certificates \
    sudo \
    vim \
    gdb-multiarch \
    device-tree-compiler \
    u-boot-tools \
    dosfstools \
    e2fsprogs \
    python3 \
    python3-pip \
    xz-utils \
    file \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# QEMU (RISC-V)
# -------------------------
RUN apt-get update && apt-get install -y \
    qemu-system-misc \
    qemu-system-riscv64 \
    && rm -rf /var/lib/apt/lists/*

RUN qemu-system-riscv64 --version

# -------------------------
# GNU RISC-V 工具链（⭐关键⭐）
# Alien kernel 链接阶段必须
# -------------------------
RUN apt-get update && apt-get install -y \
    gcc-riscv64-linux-gnu \
    binutils-riscv64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# Rust + rustup
# -------------------------
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

# -------------------------
# Rust nightly（与 Alien 兼容）
# -------------------------
RUN rustup toolchain install nightly-2025-05-01 \
    && rustup default nightly-2025-05-01 \
    && rustup component add \
        rust-src \
        llvm-tools-preview \
        rustfmt \
        clippy \
    && rustup target add riscv64gc-unknown-none-elf

# -------------------------
# musl RISC-V 工具链（user apps / libc）
# -------------------------
RUN wget -O /tmp/riscv64-linux-musl-cross.tgz \
        https://musl.cc/riscv64-linux-musl-cross.tgz \
    && tar -xzf /tmp/riscv64-linux-musl-cross.tgz -C /opt \
    && rm /tmp/riscv64-linux-musl-cross.tgz

ENV PATH="/opt/riscv64-linux-musl-cross/bin:${PATH}"

# -------------------------
# elfinfo（trace_exe 用）
# -------------------------
RUN cargo install --git https://github.com/os-module/elfinfo

# -------------------------
# 工作目录
# -------------------------
WORKDIR /workspace

# -------------------------
# sudo & mount 权限
# -------------------------
RUN echo 'root ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# -------------------------
# 网络测试端口（可选）
# -------------------------
EXPOSE 5555

# -------------------------
# 默认启动
# -------------------------
CMD ["/bin/bash"]
