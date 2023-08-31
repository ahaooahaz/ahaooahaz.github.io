---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861871079.webp
urlname: tcpdump
date: 2022-07-06 15:06:37
title: TCPDUMP学习笔记
tags:
  - technical
---

在Linux系统上的抓包工具。

<!--more-->

1. 在什么都不知道的情况下，就是想抓取当前机器上所有的跟TCPDUMP有关的包，也不管能不能看懂，应该这样做：
`sudo tcpdump`，抓取主机上第一块网卡的所有数据包，此时默认只显示数据包的头部，抓到的数据格式为`[时间] [数据包协议] [源IP].[源端口] > [目标IP].[目标端口] [目标地址协议] [协议详细信息]`，通过`CTRL C`停止抓包后，会生成该时段抓拍的统计信息。

2. 当我想指定抓取某个网卡上的数据包时：
`sudo tcpdump -i eth0`，通过`-i`选项指定要监听的网卡，这里的网卡可以通过`ifconfig`|`tcpdump -D`获取，此后抓到的数据就都为流过该网卡的数据包了。

3. 只想抓取某个协议的数据包：
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp|fddi]`。

4. 当我希望通过IP，PORT等一些相关的信息来进行过滤时：
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp] and host [ip|host] and port [port]`，通过指定host和port对抓取的数据包进行过滤，当host写在前时，第一个and是必要的。
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp] and host [ip|host] and port [port] and src [host] and dst [host]`，通过指定来源src与目标dst位置过滤数据包。
以上命令中的`and`可以与`or`相互替换，需要根据实际的使用语义进行选择。

5. 仅显示IP地址，不适用域名反解：
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp] and host [ip|host] and port [port] -n`，通过`-n`选项将域名显示为IP地址，`-nn`表示不解析域名也不解析端口，直接显示IP和端口号。

6. 我希望查看抓到的数据包的具体内容：
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp] and host [ip|host] and port [port] -X`，通过`-X`选项将包内数据的内容以10进制的形式打印在标准输出内。
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp] and host [ip|host] and port [port] -w [file]`，通过`-w [file]`选项将抓到的数据包信息以及数据包的内容写入文件中。

7. 对抓到的数据包的内容进行分析：
`sudo tcpdump -i eth0 [tcp|udp|ip|arp|rarp] and host [ip|host] and port [port] -X -A -s 0`，通过`-A`选项将数据包的内容以ASCII的形式输出, `-s 0`表示截取65535个字节的数据，默认情况下，TCPDUMP只截取96个字节。

8. 抓取HTTP GET数据包：
`sudo tcpdump -s 0 -A -vv 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'`

### 参考文献

[超详细的网络抓包神器 tcpdump 使用指南](https://juejin.cn/post/6844904084168769549)