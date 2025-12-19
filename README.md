# �� Alienos Docker

[![Docker](https://img.shields.io/badge/Docker-22.04-blue)](https://www.docker.com/)  
[![Rust](https://img.shields.io/badge/Rust-nightly-orange)](https://www.rust-lang.org/)  
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

> Docker setup for **Alien / ArceOS** development environment  
> 快速搭建一致的 Alienos 开发环境，支持 RISC-V 仿真、Rust 和 musl 工具链。

---

## 📖 目录

- [项目简介](#项目简介)
- [文件结构](#文件结构)
- [构建与运行](#构建与运行)
- [工作目录](#工作目录)
- [工具链说明](#工具链说明)
- [注意事项](#注意事项)
- [联系](#联系)

---

## 📝 项目简介

该仓库提供 Alienos / ArceOS 的 **Docker 开发环境**，包含：

- Ubuntu 22.04 基础环境  
- RISC-V QEMU 仿真环境  
- GNU RISC-V 工具链（编译内核和链接）  
- Rust nightly 与 `riscv64gc-unknown-none-elf` target  
- musl RISC-V 工具链（用于用户程序和 libc）  
- elfinfo 工具（trace_exe 调试）  

通过 Docker，开发者无需在本地手动配置复杂环境即可开始开发。

---

## 📂 文件结构

\`\`\`text
docker/
├── Dockerfile               # Docker 镜像构建文件
├── docker-compose.yml       # 基本 Docker Compose 配置
├── docker-compose.gui.yml   # GUI 可选配置
├── Makefile.docker          # Docker 相关 Make 指令
└── DOCKER_SETUP.md          # Docker 使用说明
\`\`\`

---

## ⚙️ 构建与运行

### 构建 Docker 镜像

\`\`\`bash
docker build -t alien-alien-dev .
\`\`\`

或使用 Docker Compose 构建：

\`\`\`bash
docker-compose build
\`\`\`

### 启动容器

\`\`\`bash
docker run -it --rm -v $(pwd)/workspace:/workspace -p 5555:5555 alien-alien-dev
\`\`\`

Docker Compose 启动：

\`\`\`bash
docker-compose up
\`\`\`

### 测试环境

进入容器后可运行：

\`\`\`bash
rustc --version
cargo --version
qemu-system-riscv64 --version
\`\`\`

确保工具链安装正确。

---

## 📂 工作目录

容器内默认工作目录：

\`\`\`
/workspace
\`\`\`

建议将 Alienos 项目代码挂载到该目录以便进行编译和调试。

---

## 🛠 工具链说明

| 工具 | 说明 |
|------|------|
| **RISC-V QEMU** | 用于仿真 Alien / ArceOS 系统 |
| **GNU RISC-V 工具链** | 编译 kernel 和链接阶段 |
| **Rust nightly** | 与 Alien 内核兼容的 Rust 工具链 |
| **musl RISC-V 工具链** | 编译用户程序 / libc |
| **elfinfo** | trace_exe 工具依赖，用于调试 |

---

## ⚠️ 注意事项

- Docker 容器内已配置 sudo 无密码权限  
- 网络端口 `5555` 已开放，用于调试和测试  
- 请确保宿主机有足够磁盘空间 (~5GB)  
- 构建镜像和编译可能需要较多时间，请耐心等待  

---

## 📬 联系

如有问题，请在仓库 [Issues](https://github.com/nusakom/Alienos-Docker/issues) 提问。
