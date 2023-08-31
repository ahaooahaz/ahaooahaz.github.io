---
author: ahaooahaz
image: https://source.unsplash.com/1600x900/?nature,sea,gta
urlname: negate-int-binary
date: 2021-11-25 14:19:50
title: 整型和浮点型的二进制存储与计算
tags: 
  - technical
mathjax: true
---

计算机存储数字的全部采用补码，计算也使用补码计算，当定义有符号的整型值为0，在计算机内的存储的补码二进制为`00000000`，进行取反计算后补码结果会变成`11111111`，进而通过有符号的补码转换为反码是`10000000`，再+1为`10000001`，转为十进制的结果就是`-1`。

<!--more-->

## 整型

**计算机使用补码对整型进行存储与计算**，正数的反码和补码都是它自己，负数的反码为除了符号位取反，补码为反码减1。

## 浮点数型

**计算机对浮点数的存储是通过固定宽度的符号域，指数域和尾数域，任意一个浮点数字可以通过下面的形式表示**：

<center><strong>$$Value=(-1)^s*M*2^E$$</strong></center>

其中`s`为符号位的值，当`s==0`为正数，`s==1`为负数，`M`表示有效数字，即尾数域的值，取值范围为(1,2)，整数部分固定为1，所以整数部分的1被省略，只存储小数部分的值，`E`表示指数位。


对于`float32`而言，`s`符号位占用1字节，`M`尾数域占用23字节，`E`指数域占用8字节。

对于`float64`而言，`s`符号位占用1字节，`M`尾数域占用52字节，`E`指数域占用11字节。

### `E`指数

`E`的类型为无符号的整型数字，对于8位的`E`，取值范围为[0,255]，对于`11`位的`E`，取值范围为[0,2047]，为了能让`E`表示负数，IEEE 745规定真实的`E`的值必须减去一个中间数，对于8位这个中间数位`127`，对于11位这个数字是`1024`。

### `M`指数

表示浮点数转换为二进制后，除去首位的1剩余部分的数值。

### 规定

当`E`的每一位都是0时，真实计算的`E'=1-127/1023`，并且`M`中被省略的1降级为0，这样做是为了表示±0以及接近0的很小的数字。

当`E`的每一位都是1时，如果`M`中全都为0，表示±无穷大；如果`M`不是全部为0，则表示这不是一个数（NaN）。

<center>$$eg: float32$$</center>

<center>$$3.25 = 11.01 = 1.101 * 2^1$$</center>

<center>$$M = 101$$</center>

<center>$$E = 1+127 = 128 = 10000000$$</center>

<center>$$S = 0$$</center>

<center>binary = 0 10000000 1010 0000 000000000000000</center>

### 构造正负无穷大

```golang
var inf_64_0 float64 = math.Float64frombits(2047 << 52) // 64位正无穷大
var inf_64_1 float64 = math.Float64frombits(4095 << 52) // 64位负无穷大

var inf_32_0 float32 = math.Float32frombits(255 << 23) // 32位正无穷大
var inf_32_1 float32 = math.Float32frombits(511 << 23) // 32位负无穷大
```