---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/IMG_20201004_154300.webp
title: lua学习笔记
date: 2021-08-04 17:20:58
urlname: bash-c-first-arg
tags: 
  - technical
---

<img src="/images/qingdao-dahai-jiaoshi.jpg" width="40%" height="40%"></img>
<center>青岛大海旁边的石头<br/>photo by <a href="mailto:irishong_@outlook.com">@iris</a></center>

<!--more-->

### 关键点

以脚本语言的角度看lua，每个文件末尾返回本包的主体，这样当前包才能被其他文件引用，在是用中发现，如果不指定返回值，默认返回值是一个bool类型的值

### 遍历

ipairs仅遍历数组（key为数字），遇到值为nil或者遇到不连续的索引时就停止遍历并退出，这里值为nil就可以理解为不连续的索引，值为nil的元素，认为是不存在的元素，ipairs不会遍历key值为0的元素

pairs遍历集合所有元素，包括key和value，即pairs可以遍历数组中所有的元素，当数组中某一个元素的key不为nil但是value为nil时，pairs会跳过这个元素继续遍历下一个元素。

lua是以1为索引的起始位置

### 赋值和拷贝

lua中table类型的赋值与拷贝都是在传递引用值

发现一个大问题
```lua
local m = {}
m[1] = {value = 1}
local ref = m[1]
ref.value = 2
if ref.value ~= m[1].value then
print("没引用传递阿")
end
ref = nil
if ref ~= m[1] then
print("赋值为nil确实不传递阿")
end

```
赋值为nil的操作不能理解为赋值，应当理解为对变量对应的值消除引用吧，强行理解吧，range里的应该也是一样


