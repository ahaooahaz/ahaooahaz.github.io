---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861870888.webp
urlname: gpg-failed
date: 2021-11-18 14:31:27
title: GPG学习笔记
tags: 
  - technical
---

keep your secret.

<!--more-->

## 遇到的问题

通过GPG对git commit进行签名提交时出现错误。

在公司的开发机上配置了公司内部的gitlab和我自己的github的gpg钥匙，全局的环境配的是公司的账号，只有我自己项目里面配置自己的账号，配好之后一直存在一个问题，就是通过gpg push公司项目一切正常，在push自己的项目时，会出现`error: gpg failed to sign the data`这个错误，折腾了好久都没弄好，只好一段时间内放弃了gpg，今天突然发现问题所在，原来在个人项目内，我只配置了git user和email，但是git默认会以gpg的方式提交，所以只好找到了全局的gpg账号，就发现这个gpg账号跟git email是匹配不上的，自然就报错了，当然，解决方法很简单，在自己的项目里面再设置一下user.signingkey就ok了。

一样的错误出现在我的windows/WSL里，这次的原因是因为二次验证密码窗口无法弹出，所以直接就失败了，网上搜到一个解决方案，设置一个环境变量`export GPG_TTY=$(tty)`就可以了。

[相关参考](https://networm.me/2017/08/27/signing-git-commit-with-gpg/)
