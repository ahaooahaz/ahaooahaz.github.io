---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/beijing-yonghegong-wanshang.webp
urlname: ibus-in-ubuntu20.04
slug: ibus-in-ubuntu20.04
date: 2024-01-25T15:59:24+08:00
title: ibus fixes in ubuntu20.04
tags:
  - tools
draft: false
---
<!--more-->

系统升级到ubuntu20.04之后，在浏览器中没法切换ibus输入法，只能使用fcitx来输入中文，执行`env | grep -E 'XMOD|_IM'`结果为：
```
GLFW_IM_MODULE=ibus
GTK_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
QT_IM_MODULE=fcitx
```
原因就是因为`GTK_IM_MODULE`、`XMODIFIERS`、`QT_IM_MODULE`这三个环境变量没有正确的设置。

解决方法：
创建`${HOME}/.xprofile`文件，在该文件中声明环境变量。
```
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
```
重启后环境正常。