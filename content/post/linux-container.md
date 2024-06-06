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

## 多阶段构建

# 在容器中运行docker守护进程的方式

在容器中挂载宿主机的docker.sock，此举实为在使用宿主机上的docker服务，当在运行的容器中运行第二级的容器并进行位置挂载时，源位置则代指宿主机上的位置，并不能将第一级容器内的位置挂载进第二级容器。

使用带有 `dind`标签的官方docker镜像，这种方法会在docker内部启动一个子服务，当运行挂载时，源位置仍为第一个docker服务的位置。
# docker-compose
# kubernetes