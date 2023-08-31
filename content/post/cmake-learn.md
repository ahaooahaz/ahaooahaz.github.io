---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/IMG_20201003_180559.webp
urlname: cmake-learn
date: 2022-09-27 10:13:42
title: cmake学习笔记
tags:
  - technical
---

内容包括cmake语法以及部分函数的使用方法。

<!--more-->

## MESSAGE

message可以再cmake阶段输出一些日志信息，用法为message(LEVEL ...)，通常的LEVEL可选的参数如下：

1. 不填：表示输出一条信息，也就是以行首为起始位置打印一条信息
2. STATUS：表示状态信息
3. WARNING：警告信息
4. AUTHOR_WARNING：开发者警告
5. SEND_ERROR：错误，cmake继续执行，会跳过错误的步骤
6. FATAL_ERROR：错误，终止所有处理

## INCLUDE

include用来载入并运行来自文件或模块的Cmake代码，include的参数可以是一下几种

1. moduleName: 从指定的CMAKE_MODULE_PATH中寻找moduleName.cmake文件并引入
2. filePath

## FUNCTION & MACRO

在CMAKE文件中可以定义函数（宏），在引入定义后的CMAKE文件中即可使用

```cmake
FUNCTION(function_name arg1 arg2)
    # do something
    message(status this is in function arg1: ${arg1} arg2: ${arg2})
ENDFUNCTION()


MACRO(macro_name arg1 arg2)
    # do something
    message(status this is in macro arg1: ${arg1} arg2: ${arg2})
ENDMACRO()
```

除了传入的参数以外，包含一些特殊的变量，与其他语言类似

| 变量  | 功能  | FUNCTION & MACRO |
| --- | --- | --- |
| ARGV# | #表示下标，0指向第一个参数 | 有效  |
| ARGV | 参数列表中的所有参数 | 有效  |
| ARGN | 定义以外的参数 | 有效  |
| ARGC | 传入的实际参数个数 | 有效  |

MACRO（宏）与C中对宏的定义一致，可以理解为处理器的预处理过程
