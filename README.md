# 🚀 AlienOS Development Environment

[![Rust](https://img.shields.io/badge/Rust-nightly-orange?logo=rust)](https://www.rust-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> **Alien / ArceOS** 本地开发环境一键配置工具。
> 快速搭建 AlienOS 开发环境，自动配置 RISC-V 仿真器、Rust 工具链及 musl 交叉编译环境。

---

## ⚡ 快速开始 (Quick Start)

本项目仅支持 **Ubuntu 22.04 LTS** 或更高版本。

### 1. 获取代码

```bash
git clone https://github.com/nusakom/Alienos-Docker.git alien-env
cd alien-env
```

### 2. 一键部署

运行根目录下的部署脚本：

```bash
./setup.sh
```

**脚本功能：**
- ✅ 自动安装系统基础依赖 (`build-essential`, `qemu-system-riscv64`, etc.)
- ✅ 安装/更新 Rust nightly 工具链 (`nightly-2025-05-01`)
- ✅ 添加 Rust RISC-V target (`riscv64gc-unknown-none-elf`)
- ✅ 下载并配置 `musl` RISC-V 交叉编译工具链 (至 `/opt/riscv64-linux-musl-cross`)
- ✅ 安装 `elfinfo` 调试工具

### 3. 生效环境

脚本运行完成后，请更新环境变量：

```bash
source ~/.bashrc
```

### 4. 验证安装

```bash
# 检查 Rust
rustc --version
# 输出示例: rustc 1.xx.0-nightly ...

# 检查 QEMU
qemu-system-riscv64 --version
# 输出示例: QEMU emulator version 7.x.x ...

# 检查 musl 工具链
riscv64-linux-musl-gcc --version
```

---

## 🛠 工具链清单

部署脚本将自动配置以下核心组件：

| 组件 | 版本/说明 | 用途 |
|------|-----------|------|
| **Rust Toolchain** | `nightly-2025-05-01` | AlienOS 内核编译 |
| **QEMU** | `qemu-system-riscv64` | RISC-V 系统仿真运行 |
| **GNU Toolchain** | `gcc-riscv64-linux-gnu` | 内核链接与基础编译 |
| **Musl Toolchain** | `riscv64-linux-musl-cross` | 用户态程序与 Libc 编译 |
| **Elfinfo** | `latest` | `trace_exe` 依赖分析工具 |

---

## ⚠️ 注意事项

1. **Root 权限**：脚本在安装系统包和 musl 工具链时需要 `sudo` 权限。
2. **网络环境**：脚本需要从 GitHub 和 musl.cc 下载文件，请确保网络连接畅通。
3. **Rust 版本**：为了保证兼容性，锁定使用 `nightly-2025-05-01`。

---

## 📬 联系与反馈

如有问题，请提交 [Issue](https://github.com/nusakom/Alienos-Docker/issues) 或联系维护者。
