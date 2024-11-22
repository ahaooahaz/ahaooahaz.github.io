---
author: ahaooahaz
image: https://banner2.cleanpng.com/20180525/thc/avqp19j0v.webp
urlname: my-linux-dev-env
slug: my-linux-dev-env
date: 2024-01-25T15:59:24+08:00
title: 开发环境介绍
tags:
  - tools
draft: false
weight: 80
---

<!--more-->

这篇文章是对自己日常的开发环境管理以及工作中使用的工具的介绍。毕业后日常工作都是在ubuntu桌面环境下进行开发和日常沟通的，经过不断的磨炼将自己的开发环境通过Git仓库[annal](https://github.com/ahaooahaz/annal)进行管理，在使用新机器时可以一键将所有的工具和配置同步过来。

## 初始化配置

一些关于初始化的配置保存在[configs/rcs](https://github.com/ahaooahaz/annal/tree/master/configs/rcs)，rcs的意思是"run commands"，由bashrc参考而来，在[.envrc](https://github.com/ahaooahaz/annal/blob/master/configs/rcs/.envrc)中记录所有公共的环境变量，以及所有的公共shell函数，安装时会将此文件链接到`$HOME/.envrc`位置，在`bashrc`和`zshenv`中引用此文件。

## 微信

[wechat-universal-flatpak](https://github.com/web1n/wechat-universal-flatpak)

## 终端

[kitty](https://github.com/kovidgoyal/kitty)

## shell

关于shell的相关配置记录在[configs/zsh](https://github.com/ahaooahaz/annal/tree/master/configs/zsh)中。

## 输入法

从apt安装的ibus-rime版本比较旧，不能支持lua插件的功能，但基本的功能没什么问题，推荐从[ibus-rime.AppImage](https://github.com/hchunhui/ibus-rime.AppImage)来安装，是比较新的版本，也能支持lua插件。

[rime-ice](https://github.com/iDvel/rime-ice)是一个长期维护的中文词库，[我的配置方案](https://github.com/ahaooahaz/Annal/tree/master/configs/rime)截取了其中的一部分。

> 系统升级到ubuntu20.04之后，在浏览器和一些app中不能法切换ibus输入法了，只能使用fcitx来输入中文

执行`env | grep -E 'XMOD|_IM'`结果为：

```
GLFW_IM_MODULE=ibus
GTK_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
QT_IM_MODULE=fcitx
```

可以看到`GTK_IM_MODULE`、`XMODIFIERS`、`QT_IM_MODULE`这三个环境变量依然是`fcitx`，因为我是用的是ibus框架，所以需要将这三个环境变量声明为`ibus`。

创建`${HOME}/.xprofile`文件，在该文件中声明环境变量：

```
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
```

重启后恢复正常。

> 候选框中英文和中文的水平基准线没有对齐

修改候选框字体就可以解决，我这里选择了`WenQuanYi Micro Hei Bold`字体，通过gnome插件`ibus font setting`修改即可。
