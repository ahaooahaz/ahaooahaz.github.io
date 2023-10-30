---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/qingdao-dahai-fanchaun.webp
urlname: "my-rime"
slug: "my-rime"
date: 2023-10-27T19:40:35+08:00
title: "Rime"
tags:
    - technical
draft: false
---

<!--more-->

在ubuntu上搜狗输入法用腻了，折腾一下换成rime试试。

# step1: 安装

```
Could NOT find Boost (missing: filesystem regex system)
```

用源码编译的时候需要Boost库，放弃编译，直接用apt安装

```bash
sudo apt-get install ibus-rime
```

rime看起来是同时支持fcitx和ibus两种框架，之前sougou用的是fcitx，所以现在换成ibus试试，换个口味试试。


# step2: 配置

## 设置输出源

`ubuntu18.04`

把ubuntu的输入从fcitx改为ibus。
Setting -> Region&Language -> Manager Installed Languages -> ibus.
需要下载中文支持，用来在之后将rime添加为输入源。

## 配置rime

在~/.config/ibus/rime这个目录下创建并修改\*.custom.yaml来配置rime输入法，修改之后需要通过右上角的输入法按钮重新**部署**生效，对应的命令为`ibus-daemon -rdx`。

### 快捷键

ctrl+\`和vscode的快捷键冲突了，把rime的快捷键改掉，删掉rime中ctrl+\`这个快捷键，F4有相同功能，删除~/.config/ibus/rime/default.yaml中的Control+grave这个快捷键重新部署。

### 中英文切换

TODO ...

### emoji支持

TODO ...

### 自定义词典

TODO ...

## 切换字体

~开启emoji支持后，输入栏出现emoji时会显示乱码，需要切换到支持emoji的字体。~
刚开始候选框里有很多方块，看起来像乱码一样，这是因为一些特殊字体在ibus配置的字体中无法显示，需要修改ibus候选栏的字体设置，换成ubuntu字体就会好很多，虽然还会出现方块符，但数量完全可以接受了。

## docker wechat/wxwork 支持

切换之后发现docker跑的微信和企业微信用不了了，原因是因为之前启动的时候配置的是fcitx输入源，改成ibus就行了。

自定义的配置保存在(github repo)[https://github.com/ahaooahaz/Annal/tree/master/configs/rime]。
