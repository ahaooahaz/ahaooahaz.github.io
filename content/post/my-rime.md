---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/qingdao-dahai-fanchaun.webp
urlname: "my-rime"
slug: "my-rime"
date: 2023-10-27T19:40:35+08:00
title: "Rime"
tags:
    - tools
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

`ctrl+\``与vscode打开terminal冲突修改，~/.config/ibus/rime/default.custom.yaml，只保留F4为打开设置菜单。

```yaml
patch:
    hotkeys:
    - F4
```

在设置菜单中默认使用全角的`／`符号作为分隔符，修改为半角`/`符号。

```yaml
patch:
  switcher:
    # 用半角作为设置菜单中的分隔符
    option_list_separator: "/"
```

通过`ctrl+hjkl`在侯选菜单中切换选项，Enter将选中文字输出，使用`[]`分页，Tab向下选中。

```yaml
patch:
  key_binder/bindings:
    # 使用Enter上屏选中的文字
    - when: has_menu
      accept: Return
      send: space
    # 使用'[]'上下翻页
    - when: has_menu
      accept: bracketleft
      send: Page_Up
    - when: has_menu
      accept: bracketright
      send: Page_Down
    # 选词时，通过ctrl+hjkl移动选词
    - accept: "Control+k"
      send: "Up"
      when: "composing"
    - accept: "Control+j"
      send: "Down"
      when: "composing"
    - accept: "Control+h"
      send: "Left"
      when: "composing"
    - accept: "Control+l"
      send: "Right"
      when: "composing"
    - accept: "Tab"
      send: "Down"
      when: "has_menu"
```

初始使用英文输入模式，在选中的对应输入策略下修改自定义配置文件。eg: 朙月拼音简体字: `~/.config/ibus/rime/luna_pinyin_simp.custom.yaml`

```yaml
patch:
  # 默认英文输入模式
  "switches/@0/reset": 1
```

### 中英文切换

修改在中文模式下输入了一大段文字后，切换到英文模式的行为，同样在~/.config/ibus/rime/default.custom.yaml中修改。

```yaml
patch:
  # inline_ascii: 在输入法的临时英文编辑区内输入字母、数字、符号、空格等，回车上屏后自动复位到中文
  # commit_code: 已输入的编码字符上屏并切换至西文输入模式
  # commit_text: 已输入的候选文字上屏并切换至西文输入模式
  # clear: 丢弃已输入的内容并切换至西文输入模式
  # noop: 屏蔽该切换键
  ascii_composer/switch_key:
    Caps_Lock: commit_text
    Shift_R: commit_code
    Shift_L: commit_code
```

### emoji支持

配置好emoji之后，在terminal中输入emoji子符时，末尾会出现`<fe0f>`字符，这个通过在`.zshrc`中加入`setopt COMBINING_CHARS`解决。

## 切换字体

~~开启emoji支持后，输入栏出现emoji时会显示乱码，需要切换到支持emoji的字体。~~
刚开始候选框里有很多方块，看起来像乱码一样，这是因为一些特殊字体在ibus配置的字体中无法显示，需要修改ibus候选栏的字体设置，换成ubuntu字体就会好很多，虽然还会出现方块符，但数量完全可以接受了。

## docker wechat/wxwork 支持

切换之后发现docker跑的微信和企业微信用不了了，原因是因为之前启动的时候配置的是fcitx输入源，改成ibus就行了。

*配置保存在[GitHub Repo](https://github.com/ahaooahaz/Annal/tree/master/configs/rime)*
