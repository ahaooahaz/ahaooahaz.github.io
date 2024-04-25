---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/beijing-yonghegong-wanshang.webp
urlname: use-ibus-rime-in-ubuntu20.04
slug: use-ibus-rime-in-ubuntu20.04
date: 2024-01-25T15:59:24+08:00
title: Use ibus-rime in ubuntu20.04
tags:
  - tools
draft: false
---
<!--more-->

从apt安装的ibus-rime版本比较旧，不能支持lua插件的功能，但基本的功能没什么问题，推荐从[ibus-rime.AppImage](https://github.com/hchunhui/ibus-rime.AppImage)来安装，是比较新的版本，也能支持lua插件。

[rime-ice](https://github.com/iDvel/rime-ice)是一个长期维护的中文词库，可以参考配置。[我的配置方案](https://github.com/ahaooahaz/Annal/tree/master/configs/rime)截取了其中的一部分，删掉了一些不常用的功能。

# 问题

系统升级到ubuntu20.04之后，在浏览器和一些app中不能法切换ibus输入法了，只能使用fcitx来输入中文，执行`env | grep -E 'XMOD|_IM'`结果为：
```
GLFW_IM_MODULE=ibus
GTK_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
QT_IM_MODULE=fcitx
```
原因是因为`GTK_IM_MODULE`、`XMODIFIERS`、`QT_IM_MODULE`这三个环境变量没有正确的设置。

解决方法：
创建`${HOME}/.xprofile`文件，在该文件中声明环境变量。
```
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
```
重启后恢复正常。
