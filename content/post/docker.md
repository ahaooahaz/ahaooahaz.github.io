---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861870847.webp
urlname: docker
slug: docker
date: 2021-12-29 11:01:00
title: DOCKER
tags: 
  - technical

---
<!--more-->

# 隔离机制

容器计数实现资源层面的限制和隔离依赖Linux内核提供的Control groups和Linux namespace技术。

## Linux namespace

namespace是Linux内核的一项特性，它可以对内核资源进行分区，使得一组进程可以看到一组资源；而另一组进程可以看到另一组不同的资源。该功能的原理是为一组资源和进程使用相同的namespace，但是这些namespace实际上引用的是不同的资源。
Namespace 开始进入 Linux Kernel 的版本是在 2.4.X，最初始于 2.4.19 版本。但是，自 2.4.2 版本才开始实现每个进程的 namespace。

## Control groups

简称为cgroup，cgroup是Linux内核的一个功能，用来限制、控制与分离一个进程组的资源（CPU、内存、磁盘、网络、输入输出等）。它由Google的两位工程师开发，自2008年1月正式发布的Linux内核v2.6.24开始提供此能力。

# ENV

## docker声明环境变量的方式

### Dockerfile

在Dockerfile中使用 `ENV`来设置环境变量。

```dockerfile
ENV ENV_NAME=value
```

### docker run

1. `docker run -e VAR_NAME=value ...`
2. `docker run --env-file env-file ...`
   docker run设置的环境变量可以被启动命令获取到。

### docker exec

进入容器中执行 `export`声明环境变量，再手动启动docker中的子进程。

### env-file

docker-compose支持通过配置env-file的方式声明环境变量。

# VOLUME

在容器中运行容器的方式：

1. 在容器中挂载宿主机的docker.sock，此举实为在使用宿主机上的docker服务，当在运行的容器中运行第二级的容器并进行位置挂载时，源位置则代指宿主机上的位置，并不能将第一级容器内的位置挂载进第二级容器。
2. 使用带有 `dind`标签的官方docker镜像，这种方法会在docker内部启动一个子服务，当运行挂载时，源位置仍为第一个docker服务的位置。
3. sysbox运行时环境。

<!--more-->

## localhost docker.sock

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -it docker
docker run -v /home/ahaoo:/home/ahaoo -it ubuntu
```

通过挂载宿主机docker.sock在容器内启动docker服务，这时挂载的源位置是指宿主机的源位置，并不是第一级容器内的相对位置。

## dind

```bash
docker exec -it $(docker run --privileged -d --name dind-test docker:dind) /bin/sh
docker run -v /home/ahaoo:/home/ahaoo -it ubuntu
```

通过使用 `dind`在容器内启动docker服务，挂载的位置则会指向docker内的位置，不会透传到宿主机。

## sysbox

volume same as dind

# BRIDGE-NET

今天访问一个内网网站持续连接不上，ping也ping不通，换了台机器没出现相同问题，检查了DNS和host配置都没有特殊处理，dig查了一下目标ip地址为172.20.153.43，发现有一个docker创建的虚拟网口为172.20.0.1/16，目标地址的IP落入了虚拟网口的子网中，当然找不到对应的资源了。

删除所有容器创建的桥接网络虚拟网口 `docker network rm $(docker network ls -q)`，有三个默认的不能删除
