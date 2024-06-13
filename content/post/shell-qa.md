---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/2021_10_28_093909975.webp
urlname: shell-qa
slug: shell-qa
date: 2023-03-23 17:36:10
title: SHELL-QA
tags:
  - technical
weight: 60
---

<!--more-->

# Here Documents

## 语法

```bash
<fd> <<[-] <word>
    ...
<delimiter>
```

如果省略`<fd>`，则将`...`内容读入标准输出，否则读入`<fd>`文件描述符中。

**`<delimiter>`后不能添加空格或制表符**

- **`<word>`不加引号时，`<delimiter>`必须与`<word>`一样**，`...`中支持参数展开，命令替换。
- **`<word>`加引号时，`<delimiter>`必须与`<word>`引号中的值一样**，`...`中不支持任何shell的展开。
- 当语法中的`<<`改为`<<-`时，就可以在`<delimiter>`前使用制表符，但不能使用空格，且`<delimiter>`前的制表符会被忽略。

### 重定向

```bash
<fd> <<[-] <word> > <file>
    ...
<delimiter>
```

在`<word>`后直接使用重定向。

# Here String

## 语法

```bash
<fd> <<< <string>
```
如果省略`<fd>`，则将`<string>`内容读入标准输出，否则读入`<fd>`文件描述符中。



# `git commit`由于`gpg`导致失败

通过GPG对git commit进行签名提交时出现错误。

在公司的开发机上配置了公司内部的gitlab和我自己的github的gpg钥匙，全局的环境配的是公司的账号，只有我自己项目里面配置自己的账号，配好之后一直存在一个问题，就是通过gpg push公司项目一切正常，在push自己的项目时，会出现`error: gpg failed to sign the data`这个错误，折腾了好久都没弄好，只好一段时间内放弃了gpg，今天突然发现问题所在，原来在个人项目内，我只配置了git user和email，但是git默认会以gpg的方式提交，所以只好找到了全局的gpg账号，就发现这个gpg账号跟git email是匹配不上的，自然就报错了，当然，解决方法很简单，在自己的项目里面再设置一下user.signingkey就ok了。

一样的错误出现在我的windows/WSL里，这次的原因是因为二次验证密码窗口无法弹出，所以直接就失败了，网上搜到一个解决方案，设置一个环境变量`export GPG_TTY=$(tty)`就可以了。

[相关参考](https://networm.me/2017/08/27/signing-git-commit-with-gpg/)
