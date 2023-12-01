---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/firefox-google.webp
urlname: "firefox"
slug: "firefox"
date: 2023-12-01T16:56:39+08:00
title: "把CHROME换成了FIREFOX"
tags:
  - tools
draft: false
---

<!--more-->

一直在用CHROME有点腻了，最主要的原因还是觉得CHROME上面标题栏+输入框+标签列在最上面占用太宽了，所以一直依赖都是把标签隐藏起来，用的时候再打开，但还是觉得不够精简。看到一篇文章写了FIREFOX可以把最顶层的标题栏隐藏掉，所以换FIREFOX。

首先把机器的FIREFOX更到最新版本，老版本的也太丑了，插件图标间隔太大了。

当然不能没有标题栏，目标是将水平标题栏改成垂直标题栏，下载插件`Sidebery`，通过快捷键`CTRL+e`打开/关闭。

接下来隐藏水平标题栏，FIREFOX支持通过CSS定制界面，对应的 CSS 规则需要保存到名为 userChrome.css 的文件。而且这个文件需要放到 profile 文件夹下的 chrome 文件夹。

通过`[HELP]` -> `[More Troubleshooting Information]`会打开一个信息界面，搜索`[Profile Directory]`可以查找到配置文件所在的目录，点击`[OPEN]`，在这个文件夹中创建一个新文件夹`chrome`，并且把`userChrome.css`拷贝到这个文件夹中。

```css
#TabsToolbar {
  visibility: collapse;
}
```

69 版本开始，Firefox 默认不再自动加载 userChrome.css 文件。需要手工开启这个特性。

1. 访问 `about:config`
2. 搜索 `userprof`
3. 将`toolkit.legacyUserProfileCustomizations.stylesheets`改为`true`

重启FIREFOX即可。

现在隐藏掉标签栏，浏览器上面只有一个输入框宽度了。

参考链接:
- https://taoshu.in/firefox/vertical-tabs.html
