---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/mmexport1603125604287.webp
title: bash -c的$1不是第一个参数
date: 2021-08-26 17:08:19
urlname: lua-questions
tags:
  - technical
---

<img src="/images/qingdao-dahai-fanchaun.jpg" width="40%" height="40%"></img>
<center>青岛大海上的帆船<br/>photo by <a href="mailto:irishong_@outlook.com">@iris</a></center>

通常`$0`表示当前执行的脚本文件，但在使用bash -c时，`$0`表示命令行参数的第一个参数。

<!--more-->

我认为这是因为bash -c的命令不是来自具体的文件，所以传统的$0脚本文件位置会空出来，这个时候的参数就会依次补上来，用一个参数把$0这个位置占掉就ok了。

举个例子吧

`bash -c 'ls $@' -a`这样，`-a`其实是作为`$0`传递进去的，`bash -c 'ls $@' x -a`这样才是正确的！