# Alien OS Docker 开发环境设置指南

本指南帮助你在 macOS 上使用 Docker 搭建 Alien OS 的开发环境，无需修改项目代码。

## 前置要求

1. **Docker Desktop for Mac**
   - 下载并安装 [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - 启动 Docker Desktop 并确保其正常运行

2. **系统要求**
   - macOS 10.15 或更高版本
   - 至少 4GB 可用内存
   - 至少 10GB 可用磁盘空间

## 快速开始

### 1. 构建开发环境

```bash
# 进入项目目录
cd Alien

# 给脚本添加执行权限
chmod +x scripts/docker-dev.sh

# 构建 Docker 镜像（首次运行需要一些时间）
./scripts/docker-dev.sh build
```

### 2. 启动开发环境

```bash
# 启动容器
./scripts/docker-dev.sh start

# 进入开发环境
./scripts/docker-dev.sh enter
```

### 3. 编译和运行 Alien OS

在 Docker 容器内：

```bash
# 查看可用命令
make help

# 编译并运行（无 GUI）
make run

# 编译并运行（带 GUI，需要额外配置）
make run GUI=y

# 运行测试
cd tests
./final_test
```

## 详细使用说明

### 开发脚本命令

```bash
# 构建开发环境镜像
./scripts/docker-dev.sh build

# 启动开发环境
./scripts/docker-dev.sh start

# 进入开发环境 shell
./scripts/docker-dev.sh enter

# 停止开发环境
./scripts/docker-dev.sh stop

# 清理并重建环境
./scripts/docker-dev.sh clean

# 快速编译并运行 Alien OS
./scripts/docker-dev.sh run

# 显示帮助信息
./scripts/docker-dev.sh help
```

### 直接使用 Docker Compose

如果你熟悉 Docker Compose，也可以直接使用：

```bash
# 构建并启动
docker-compose up -d

# 进入容器
docker-compose exec alien-dev /bin/bash

# 停止
docker-compose down
```

### 开发环境特性

- **Rust nightly-2024-05-01**: 项目指定的 Rust 版本
- **QEMU 7.0.0+**: 支持 RISC-V 64 位架构
- **RISC-V 工具链**: 完整的交叉编译工具链
- **构建工具**: make, gcc, 设备树编译器等
- **调试工具**: GDB 多架构支持
- **文件系统工具**: FAT32 和 ext4 支持

## 常见问题

### Q: 首次构建很慢怎么办？
A: 这是正常的，Docker 需要下载基础镜像和安装所有依赖。后续构建会使用缓存，速度会快很多。

### Q: 如何在 macOS 上使用 GUI 模式？
A: GUI 模式需要 X11 转发。你可以：
1. 安装 XQuartz: `brew install --cask xquartz`
2. 启动 XQuartz 并允许网络连接
3. 设置 DISPLAY 环境变量
4. 修改 docker-compose.yml 添加 X11 转发配置

### Q: 容器内的文件修改会丢失吗？
A: 不会。项目目录通过 volume 挂载，所有修改都会保存到宿主机。

### Q: 如何清理 Docker 占用的空间？
A: 运行 `./scripts/docker-dev.sh clean` 或使用 Docker Desktop 的清理功能。

### Q: 编译出错怎么办？
A: 检查：
1. Docker 容器是否有足够内存（建议 4GB+）
2. 磁盘空间是否充足
3. 网络连接是否正常（下载依赖时需要）

## 高级配置

### 自定义构建参数

你可以修改 `docker-compose.yml` 来自定义构建参数：

```yaml
environment:
  - SMP=2          # CPU 核心数
  - GUI=n          # 是否启用 GUI
  - FS=fat         # 文件系统类型
  - NET=y          # 是否启用网络
```

### 持久化数据

重要的构建缓存已经通过 Docker volumes 持久化：
- Cargo 注册表缓存
- Cargo Git 缓存
- 构建目标文件

### 网络配置

容器默认映射了 5555 端口，用于网络功能测试。如需其他端口，请修改 `docker-compose.yml`。

## 故障排除

### 重置环境

如果遇到问题，可以完全重置环境：

```bash
# 停止并删除容器
docker-compose down -v

# 删除镜像
docker rmi alien_alien-dev

# 重新构建
./scripts/docker-dev.sh build
```

### 查看日志

```bash
# 查看容器日志
docker-compose logs alien-dev

# 实时查看日志
docker-compose logs -f alien-dev
```

## 贡献

如果你发现配置问题或有改进建议，欢迎提交 Issue 或 Pull Request。

## 许可证

本 Docker 配置遵循与 Alien OS 项目相同的许可证。