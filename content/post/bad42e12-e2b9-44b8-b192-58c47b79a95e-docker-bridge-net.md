---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/mmexport1635076881455.webp
urlname: bad42e12-e2b9-44b8-b192-58c47b79a95e-docker-bridge-net
date: 2021-10-12 14:29:51
title: 容器桥接网络造成ip冲突
tags: docker
---

今天访问一个内网网站持续连接不上，ping也ping不通，换了台机器没出现相同问题，检查了DNS和host配置都没有特殊处理，dig查了一下目标ip地址为172.20.153.43，发现有一个docker创建的虚拟网口为172.20.0.1/16，目标地址的IP落入了虚拟网口的子网中，当然找不到对应的资源了。

删除所有容器创建的桥接网络虚拟网口`docker network rm $(docker network ls -q)`，有三个默认的不能删除
