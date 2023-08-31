---
author: ahaooahaz
image: https://source.unsplash.com/1600x900/?nature,sea,gta
urlname: golang-tips
date: 2021-10-12 17:07:18
title: Golang学习笔记
tags:
  - technical
---

<img src="/images/beijing-yonghegong-wanshang.jpg" width="40%" height="40%"></img>
<center>北京夜晚的雍和宫<br/>photo by <a href="mailto:irishong_@outlook.com">@iris</a></center>

<!--more-->

## 结构体嵌套

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

## 条件编译

### 平台区分

源文件`xxx_$(GOOS)_$(GOARCH).go`仅会在`go build GOARCH=$(GOARCH) GOOS=$(GOOS) .`时被编译

源文件`xxx_$(GOOS).go`会在`go build GOOS=$(GOOS) .`时被编译，这时`GOARCH`无论是什么都不会造成影响

源文件`xxx_$(GOARCH).go`会在`go build GOARCH=$(GOARCH) .`时被编译，这是无论`GOOS`是什么都不影响

### 自定义区分

通过build tag进行条件编译，在文件的第一行，必须是第一行，添加`//+build $tag`，然后在编译的时候添加`go build -tags=$tag`来编译，这样就只会把头部包含`//+build $tag`的源文件编译进去。

当平台区分和自定义区分同时存在，优先进行平台区分

## 多层跳转

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
