#!/usr/bin/env bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}[+] AlienOS One-Click Local Setup${NC}"

# Check for sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "${YELLOW}Please run with sudo privileges only for apt steps if prompted, or run as root if you prefer.${NC}"
  # We don't exit because some steps don't need sudo, but apt does. 
  # sudo commands are prefixed with sudo in the script.
fi

echo -e "${GREEN}[1/6] Installing System Dependencies...${NC}"
sudo apt update
sudo apt install -y \
  curl wget git build-essential pkg-config libssl-dev \
  ca-certificates sudo vim \
  gdb-multiarch \
  device-tree-compiler \
  u-boot-tools \
  dosfstools e2fsprogs \
  python3 python3-pip \
  xz-utils file

echo -e "${GREEN}[2/6] Installing QEMU...${NC}"
sudo apt install -y \
  qemu-system-misc \
  qemu-system-riscv64
qemu-system-riscv64 --version

echo -e "${GREEN}[3/6] Installing GNU RISC-V Toolchain...${NC}"
sudo apt install -y \
  gcc-riscv64-linux-gnu \
  binutils-riscv64-linux-gnu

echo -e "${GREEN}[4/6] Setting up Rust...${NC}"
if ! command -v rustup >/dev/null; then
  echo "Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
else
  echo "Rustup already installed."
fi

# Ensure cargo is in path
export PATH="$HOME/.cargo/bin:$PATH"

echo "Installing Rust nightly-2025-05-01..."
rustup toolchain install nightly-2025-05-01
rustup default nightly-2025-05-01

rustup component add \
  rust-src \
  llvm-tools-preview \
  rustfmt \
  clippy

echo "Adding RISC-V target..."
rustup target add riscv64gc-unknown-none-elf

echo -e "${GREEN}[5/6] Checking/Installing musl RISC-V Toolchain...${NC}"
MUSL_PATH="/opt/riscv64-linux-musl-cross"
if [ ! -d "$MUSL_PATH" ]; then
  echo "Downloading musl toolchain..."
  wget -O /tmp/riscv64-linux-musl-cross.tgz \
    https://musl.cc/riscv64-linux-musl-cross.tgz
  echo "Extracting to /opt..."
  sudo tar -xzf /tmp/riscv64-linux-musl-cross.tgz -C /opt
  rm /tmp/riscv64-linux-musl-cross.tgz
else
  echo "Musl toolchain already exists at $MUSL_PATH"
fi

# Add to PATH in .bashrc if not present
if ! grep -q "riscv64-linux-musl-cross/bin" "$HOME/.bashrc"; then
  echo 'export PATH=/opt/riscv64-linux-musl-cross/bin:$PATH' >> "$HOME/.bashrc"
  echo "Added musl toolchain to .bashrc"
fi

# Export for current session (though this script runs in subshell)
export PATH=/opt/riscv64-linux-musl-cross/bin:$PATH

echo -e "${GREEN}[6/6] Installing elfinfo...${NC}"
if ! command -v elfinfo >/dev/null; then
  cargo install --git https://github.com/os-module/elfinfo
else
  echo "elfinfo already installed"
fi

echo -e "${BLUE}=======================================${NC}"
echo -e "${GREEN}[✓] Setup Complete!${NC}"
echo -e "${YELLOW}Please run 'source ~/.bashrc' or restart your terminal to update PATH.${NC}"
echo -e "${BLUE}=======================================${NC}"
