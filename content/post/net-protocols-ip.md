---
author: ahaooahaz
image: 
urlname: net-protocols-ip
slug: net-protocols-ip
date: 2024-06-25T18:02:48+08:00
title: Net Protocols Ip
tags:
  - technical
  - network
draft: true
weight: 60
---
<!--more-->
# IP地址
## IPv4地址
IPv4地址占用4字节，通过点分十进制转换为4个十进制的数字，即常见的IP地址。
### 分类网络
在早期阶段，网络号始终是由前八个比特位表示，这样的方式最多只允许256个网络使用，这样的方式很显然是不够用的，因此引入了分类网络。
分类网络规定IPv4具有一定的结构，有五个类型，地址可分为A、B、C、D、E五大类，其中**E类**属于特殊保留地址。
在A类、B类、C类IP地址中，如果主机号是全1，那么这个地址为直接广播地址，它是用来使路由器将一个分组以广播形式发送给特定网络上的所有主机。`255.255.255.255`为**受限广播地址**，用来将一个分组以广播方式发送给本网络中所有的主机，路由器则阻挡该分组通过，将广播功能限制在本网络内部。
#### A类地址
A类地址的首个比特位固定为`0b0`，首个字节表示网络ID，后3字节表示主机地址。
##### 范围
A类地址的范围为`0.0.0.0`-`127.255.255.255`。
```text
|<-------------------16 bits------------------->|

0                       8                       16
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|0 | NETWORK ID         |    HOST ID            |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                  HOST ID                      |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```
#### B类地址
B类地址的前两个比特位固定为`0b10`，前2字节表示网络ID，后2字节表示主机地址。
##### 范围
B类地址的范围为`128.0.0.0`-`191.255.255.255`。
```text
|<-------------------16 bits------------------->|

0                       8                       16
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|1 |0 |             NETWORK ID                  |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                  HOST ID                      |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

```
#### C类地址
C类地址的前两个比特位固定为`0b110`，前3字节表示网络ID，后1字节表示主机地址。
##### 范围
C类地址的范围为`192.0.0.0`-`223.255.255.255`。
```text
|<-------------------16 bits------------------->|

0                       8                       16
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|1 |1 |0 |          NETWORK ID                  |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|       NETWORK ID      |       HOST ID         |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```
#### D类地址
D类地址的前四个比特位固定为`0b1110`，D类地址部分网络地址和主机地址，剩余的比特位都表示多播组号。
##### 范围
D类地址的范围为`224.0.0.0`-`239.255.255.255`。
```text
|<-------------------16 bits------------------->|

0                       8                       16
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|1 |1 |1 |0 |       MULTICAST  ADDRESS          |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|              MULTICAST  ADDRESS               |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```
#### E类地址
E类地址的前五个比特位固定为`0b11110`，剩余比特位保留。
```text
|<-------------------16 bits------------------->|

0                       8                       16
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|1 |1 |1 |1 |0 |                                |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                                               |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```
### 无类别域间路由
无类别域间路由（Classless Inter-Domain Routing，简称CIDR）规定一个IPv4地址包含两部分，标识网络的前缀和网络内的主机地址，无类别域间路由是基于可变长子网掩码（VLSM）来进行任意长度的前缀分配的，遵从CIDR规则的地址有一个后缀来说明前缀的位数，例如：`192.168.1.0/24`表示前24位为前缀地址，后8位为网络内的主机地址。
#### 子网掩码
一个子网掩码一共有32位，由两部分组成，高位部分每一位都为`1`，其余部分均为`0`，其中`1`的位数与前缀的长度相同。
### IPv4私有地址
[RFC 1918](https://tools.ietf.org/html/rfc1918)中规定了三个地址块作为私有地址。
- `10.0.0.0`-`10.255.255.255`
- `172.16.0.0`-`172.31.255.255`
- `192.168.0.0`-`192.168.255.255`
这三个网络中的IPv4地址不可以作为公网地址来给外部访问，只能在局域网中被访问。