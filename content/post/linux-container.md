---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861870847.webp
urlname: linux-container
slug: linux-container
date: 2021-12-29 11:01:00
title: 容器技术
tags: 
  - technical
---
<!--more-->
容器技术为应用程序提供了完成的运行环境，可以让应用程序在任何支持容器技术的设备上运行。除了docker之外，还有podman等容器技术。

容器实现资源层面的限制和隔离依赖Linux内核提供的Control groups和Linux namespace技术。

# Linux namespace
namespace是Linux内核的一项特性，它可以对内核资源进行分区，使得一组进程可以看到一组资源；而另一组进程可以看到另一组不同的资源。该功能的原理是为一组资源和进程使用相同的namespace，但是这些namespace实际上引用的是不同的资源。
Namespace 开始进入 Linux Kernel 的版本是在 2.4.X，最初始于 2.4.19 版本。但是，自 2.4.2 版本才开始实现每个进程的 namespace。

# Control groups
简称为cgroup，cgroup是Linux内核的一个功能，用来限制、控制与分离一个进程组的资源（CPU、内存、磁盘、网络、输入输出等）。它由Google的两位工程师开发，自2008年1月正式发布的Linux内核v2.6.24开始提供此能力。

# docker
## 镜像
### 分层存储
在构建镜像时，会一层一层构建，每一层构建完成不再发生改变，后一层发生的任何改变只发生在自己的这一层，比如删除前一层的某一个文件，不会真正删除前一层的文件，只会在当前层标记该文件的已被删除状态。
用不同的Dockerfile构建3个镜像并查看镜像占用的大小：
```dockerfile
// image:1
FROM ubuntu:18.04
WORKDIR /
RUN dd if=/dev/zero of=2GB_file bs=1M count=2048
```
```dockerfile
// image:2
FROM ubuntu:18.04
WORKDIR /
RUN dd if=/dev/zero of=2GB_file bs=1M count=2048
RUN rm -rf 2GB_file
```
```dockerfile
// image:3
FROM ubuntu:18.04
WORKDIR /
RUN dd if=/dev/zero of=2GB_file bs=1M count=2048; rm -rf 2GB_file
```
占用的大小分别为：
```bash
image:3 63.2MB
image:2 2.21GB
image:1 2.21GB
```
## 容器
容器在运行时，会以镜像为基础，在镜像之上再创建一层容器的存储层，生命周期跟随容器的生命周期，任何保存在容器存储层的信息都会随着容器的删除而删除。
# Dockerfile
通过一系列的命令来构建镜像。
## 支持的命令
- FROM: 指定基础镜像。`scratch`表示一个空白的镜像。
- RUN: 在上层镜像之上执行特定命令。
- COPY: 从构建的*上下文目录*中拷贝文件或目录到镜像的指定位置。
- ADD: 在COPY的基础上增加了从URL下载的功能，下载后默认权限为600。
- CMD: 指定容器的启动程序和参数。
- ENTRYPOINT: 指定容器的启动程序和参数。**当ENTRYPOINT存在时，CMD的内容会作为参数传递给ENTRYPOINT**。
- ENV: 设置环境变量。在Dockerfile的构建过程中和容器运行时都会生效。
- ARG: 设置构建过程中的环境变量。在容器运行时不存在。
- VOLUME: 指定目录挂载为匿名卷，在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。
- EXPOSE: 指定容器运行时提供服务的端口，仅声明，在运行时使用随机端口映射时，会自动随机映射EXPOSE的端口。
- WORKDIR: 指定镜像内的工作目录，如果不存在会自动创建。
- USER: 切换到指定用户，该用户必须是事先创建好的。
- HEALTHCHECK: 设置检查容器健康状况的命令。
- HEALTHCHECK NONE: 如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令。
- ONBUILD: 后面跟其他指令，在当前镜像构建时并不会被执行，只有当以当前镜像为基础镜像去构建下一级镜像时才会被执行。
- LABEL: 为镜像添加元数据。
- SHELL: 指定RUN、ENTRYPOINT、CMD指令的解释器。

# 在容器中运行docker守护进程的方式

在容器中挂载宿主机的docker.sock，此举实为在使用宿主机上的docker服务，当在运行的容器中运行第二级的容器并进行位置挂载时，源位置则代指宿主机上的位置，并不能将第一级容器内的位置挂载进第二级容器。

使用带有 `dind`标签的官方docker镜像，这种方法会在docker内部启动一个子服务，当运行挂载时，源位置仍为第一个docker服务的位置。
# docker-compose
通过一个单独的yaml文件定义一组相关联的服务（容器）组成一个完整的项目。docker-compose的默认管理对象是项目。
## 模板文件
每一个服务（容器）都必须通过image或者build来声明运行的镜像。
### build
指定Dockerfile所在的文件夹路径，docker-compose会自动构建镜像并使用。
```yaml
version: '3'
services:
  app:
    build: ./dir
```
# kubernetes