---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861870967.webp
urlname: golang
slug: golang
date: 2021-10-12 17:07:18
title: GOLANG
tags:
  - technical
weight: 60
---

<!--more-->

# 条件编译

## 平台区分

源文件`xxx_$(GOOS)_$(GOARCH).go`仅会在`go build GOARCH=$(GOARCH) GOOS=$(GOOS) .`时被编译

源文件`xxx_$(GOOS).go`会在`go build GOOS=$(GOOS) .`时被编译，这时`GOARCH`无论是什么都不会造成影响

源文件`xxx_$(GOARCH).go`会在`go build GOARCH=$(GOARCH) .`时被编译，这是无论`GOOS`是什么都不影响

## 自定义区分

通过build tag进行条件编译，在文件的第一行，必须是第一行，添加`//+build $tag`，然后在编译的时候添加`go build -tags=$tag`来编译，这样就只会把头部包含`//+build $tag`的源文件编译进去。

当平台区分和自定义区分同时存在，优先进行平台区分

# 多层跳转

对for循环设置`label`，当循环嵌套了多层，需要从最里面的循环跳到最外面或者跳转到指定的某一层循环，可以通过`break`/`continue`+`label`的方式跳转。用来控制循环跳转的`label`只能标记循环，而`break`和`continue`之后的`label`只能为标记循环的`label`。

```go
package main

func testbk() {
first:
    for {
        for {
            break first
        }
        print("first inside")
    }
    print("first outside")
}

func main() {
    testbk();
}

```

# Go调C

`import "C"`之前的注释即为要调用的C语言源码，中间不能有空行或者其他内容。

## 用源码

### C源码在Go文件中

```go
package main

/*

void hello_world_inside() {
	printf("hello world inside!\n");
}

*/
import "C"

func main() {
    C.hello_world_inside()
}

```

### C源码在Go文件外

当c代码头文件和源码分离时，~~需要注意这种方法不能在main包中使用，只能用于除main包之外的包。~~，之前不行是因为编译的时候只编译了`main.go`，没有编译c代码所以会产生链接错误，以包的方式编译就可以了。

[sample](https://github.com/AHAOAHA/Demo/tree/master/golang/cgo/cgo-1)

## 用库

需要确保代码可找到库的位置，若不在系统的链接位置，需要用-L指明。

> 这里可以用`${SRCDIR}`表示当前go文件所在的位置

```go
package main

/*

#cgo CFLAGS: -I ${SRCDIR} -std=c99
#cgo LDFLAGS: -L ${SRCDIR} -lhelloworld

#include "hello-world-lib.h"

*/
import "C"

func main() {
    C.hello_world_lib()
}

```

# C函数调用Go代码

## Go生成动/静态库

这种方法指的是通过go代码生成静态或动态库来给c代码调用。

```go
package main

//extern void hello_world_in_go();
import "C"
import "fmt"

//export hello_world_in_go
func hello_world_in_go() {
    fmt.Printf("hello world in go!\n")
}

func main() {}

/// go build -buildmode=c-archive -o helloworld.a main.go 生成静态库和头文件
/// go build -buildmode=c-shared -o helloworld.so main.go 生成动态库和头文件
```

- **`-buildmode=c-archive`生成静态库**
- **`-buildmode=c-shared`生成动态库**
- **`package main`和`main`函数是必须的**

## 回调函数

在C中声明一个回调函数，通过export在go代码中实现c代码中的声明的函数。

```go
package main

//extern void hello_world_in_go();
import "C"
import "fmt"

//export hello_world_in_go
func hello_world_in_go() {
    fmt.Printf("hello world in go!\n")
}

func main() {
    C.hello_world_in_go()
}
```

## 参数传递

主要的方法就是在Go中定义一个内存占用与C语言中一致的结构体，然后将地址强制转换为C代码中的地址。

### 传入传出函数

```go
package main

/*
struct Bus {
    int x;
    int y;
    int sum;
};

void add(struct Bus* ps) {
    ps->sum = ps->x + ps->y;
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

type Bus struct {
	x   int32
	y   int32
	sum int32
}

func main() {
	b := &Bus{
		x: 1,
		y: 1,
	}

	var pb *C.struct_Bus = (*C.struct_Bus)(unsafe.Pointer(b))
	C.add(pb)
	fmt.Printf("Bus.sum: %d\n", b.sum)
}
```

这样做也是可以的，关键的问题就在于确定C中结构体对应的大小，这里的`int`在32位或64位的平台下编译都是4个字节的，不知道为啥曾经听说会随着平台改变，查了下，会改变的是`short int`，32位2字节64位4字节，golang默认编译的是64位，通过`GOGCCFLAGS`这个环境变量就能查到其中`-m64`就代表的是64位平台。

# GO语言的GMP协程调度模型

在操作系统中，线程是调度的基本单位，在编程语言中都支持通过系统调用接口创建线程来实现编程中的并发执行模型，这样的话，对于不同执行流的调度就是由操作系统来负责；在Go语言中，引入了不同的概念，Go语言实现了自己的执行流调度器，Go语言中调度的基本单位是协程（goroutine）。
## 调度模型的发展
### 单进程单线程时代
在单进程时代，CPU没有调度不同线程的功能，只能一个任务接一个任务的处理。
#### 弊端 ^1
1. 单一的执行流程，计算机只能一个任务一个任务处理。
2. 进程阻塞带来CPU资源的浪费。
### 多进程多线程时代
引入CPU调度器之后则进入了多进程多线程的时代，CPU通过时间片来调度不同的线程。
#### 发展
解决了单进程单线程时代的弊端[[#^1]]。但仍然存在不足之处。
#### 弊端
1. 高内存占用
2. 调度线程高消耗CPU
### 协程时代
#### 为什么需要协程
携程的发展也是为了解决多进程多线程时代的不足之处。CPU调度系统中的线程时，需要不断进行线程上下文之间的切换，在切换不同线程的上下文时，CPU会产生一定的切换成本，当系统中的线程数量上升时，切换上下文的成本就会被放大，会造成调度消耗很多的CPU资源。

工程师发现其实一个线程分为 “内核态 “线程和” 用户态 “线程。
一个 “用户态线程” 必须要绑定一个 “内核态线程”，但是 CPU 并不知道有 “用户态线程” 的存在，它只知道它运行的是一个 “内核态线程”(Linux 的 PCB 进程控制块)。
多进程多线程时代的“用户线程”和“内核线程”是1:1的，那么在理想情况下，当操作系统中线程数量很大时，此时如果减少内核线程的数量，就可以解决CPU由于调度而产生的高消耗，这就是协程的基本概念。图中的用户线程就表示协程。
#### 绑定模型
##### 1:1
1个协程绑定1个线程，这就是当前多进程多线程时代的调度模型。
##### N:1
N个协程绑定到单个内核线程上。优点就是**协程在用户态线程即完成切换，不会陷入到内核态，这种切换非常的轻量快速**。但也有很大的缺点，1 个进程的所有协程都绑定在 1 个线程上
缺点：
- 某个程序用不了硬件的多核加速能力。
- 一旦某协程阻塞，造成线程阻塞，本进程的其他协程都无法执行了，根本就没有并发的能力了。
##### N:M
N:1 和 1:1 类型的结合，克服了以上 2 种模型的缺点，但实现起来最为复杂。
协程跟线程是有区别的，线程由 CPU 调度是抢占式的，**协程由用户态调度是协作式的**，一个协程让出 CPU 后，才执行下一个协程。

## Go语言GMP调度模型
### 被废弃的GM调度模型
**使用全局队列存储所有等待被调度的协程G，线程M从全局队列中读取协程G并执行。**
M 想要执行、放回 G 都必须访问全局 G 队列，并且 M 有多个，即多线程访问同一资源需要加锁进行保证互斥 / 同步，所以全局 G 队列是有互斥锁进行保护的。
老调度器有几个缺点：
- 创建、销毁、调度 G 都需要每个 M 获取锁，这就形成了激烈的锁竞争。
- M 转移 G 会造成延迟和额外的系统负载。比如当 G 中包含创建新协程的时候，M 创建了 G’，为了继续执行 G，需要把 G’交给 M’执行，也造成了很差的局部性，因为 G’和 G 是相关的，最好放在 M 上执行，而不是其他 M’。
- 系统调用 (CPU 在 M 之间的切换) 导致频繁的线程阻塞和取消阻塞操作增加了系统开销。
### GMP调度模型
引入P(process)来组合一组协程，M线程想要执行G首先必须获取P，从P的本地队列中获取G来执行，当P的队列为空时，M会尝试从全局队列拿一批G放到P的本地队列，或者从其他的P的本地列表偷取一般放到自己的本地队列，当G运行完之后，M会从当前P获取下一个G继续运行。
**全局队列（Global Queue）**：存放等待运行的 G。
#### G(goroutine)
G表示协程，取名是来自goroutine的首字母，goroutine可以理解为Go语言实现的调度器调度的基本单位，在代码中通过`go`关键字创建。
goroutine具有以下特点：
- 相比线程更小的启动代价，以很小的栈空间启动
- 工作在用户态，调度器调度时切换的成本很小
#### M(machine)
M在Go语言中**等同于操作系统线程**，取名来自machine的首字母。
M线程想运行G就得获取P，从 P 的本地队列获取 G，P 队列为空时，M 也会尝试从全局队列拿一批 G 放到 P 的本地队列，或从其他 P 的本地队列偷一半放到自己 P 的本地队列。M 运行 G，G 执行之后，M 会从 P 获取下一个 G，不断重复下去。
#### P(process)
**所有的 P 都在程序启动时创建，并保存在数组中，最多有 GOMAXPROCS(可配置) 个**。P取名来自process的首字母，**它包含了运行G(goroutine)的资源**，如果线程想运行G(goroutine)，必须先获取P(process)，P(process)中还包含了可运行的G(goroutine)队列。
**P 的本地队列**：同全局队列类似，存放的也是等待运行的 G，存的数量有限，不超过 256 个。新建 G’时，G’优先加入到 P 的本地队列，如果队列满了，则会把本地队列中一半的 G 移动到全局队列。
