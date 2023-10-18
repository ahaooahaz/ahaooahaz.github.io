---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861870967.webp
urlname: golang
slug: golang
date: 2021-10-12 17:07:18
title: GOLANG
tags:
  - technical
---

<!--more-->

# 结构体嵌套

今天发现，结构体嵌套，不需要另外指定名称，直接使用嵌套的结构体名就行，写两个例子记录一下

```go
package main

type SubSt struct {
    subx int
}

type St struct {
    SubSt
    x int
}

func main() {
    x := St{}
    x.SubSt.subx = 0 // 这样就可以访问
}
```

不在同一个包的嵌套也可以这样使用，访问时不需要加包名，直接通过类型名访问，类型可以为值或者指针，值和指针的访问方式是一样的

**当然这样也有缺点，就是嵌套的结构体内，相同的类型只能嵌套一次，而且就算是不同包的子类型，名称也不能一致**

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

* **`-buildmode=c-archive`生成静态库**
* **`-buildmode=c-shared`生成动态库**
* **`package main`和`main`函数是必须的**

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
