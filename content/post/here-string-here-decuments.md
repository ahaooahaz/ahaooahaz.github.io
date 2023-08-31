---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/2021_10_28_093909975.webp
urlname: here-string-here-decuments
date: 2023-03-23 17:36:10
title: Here Document & Here String
tags:
  - technical
---

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


