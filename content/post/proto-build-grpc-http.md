---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/mmexport1602608119485.webp
urlname: proto-build-grpc-http
date: 2021-11-02 14:51:07
title: 用Protobuf定义RPC和HTTP服务
tags:
  - technical
---

<!--more-->

## plugins

| 插件 | 功能 | 版本 | 备注 |
| --- | --- | --- | --- |
| `protoc` | 调用编译程序 | `v3.17.3` | |
| `protoc-gen-go` | 编译message结构体 | `-` | |
| `protoc-gen-go-grpc` | 编译grpc接口 | `v1.0.1` | |
| `protoc-gen-grpc-gateway` | 编程http接口 | `-` | |
| `protoc-gen-swagger` | 生成swagger文档 | `-` | |
| `protoc-gen-validate` | 生成validate格式校验 | `v0.6.2` | [#570](https://github.com/envoyproxy/protoc-gen-validate/issues/570) |

## sample

```proto

syntax = "proto3";

package message;
option go_package = "/;gen";

import "google/api/annotations.proto";

service Serv {
    rpc SayHelloWorld (request) returns (response) {
        option (google.api.http) = {
            get: "/helloworld"
        };
    };
}

message request {}

message response {
    string raw = 1;
}

```

### `go_package`

`go_package`指定生成的go文件的包名，选项的值分为两部分，分号之前表示生成文件的路径，路径的`/`根目录是指`protoc`编译时选项`--go_out`指定的位置，分号之后的第二部分表示生成文件的包名

### `package`

`package`表示当前proto文件的包

### `import`

`google/api/annotations.proto`是编译http接口必须依赖的文件，引用了这个文件直接编译会出现错误，因为`protoc`找不到这个文件的位置，`import`的包位置是从根目录开始的文件位置，这里的根目录是指`$GOPATH/src`所在的路径，解决的方法有两种，可以把文件拷贝到对应位置，也可以用`protoc`的选项来添加可选根目录的位置，他是一个数组，通过`--proto_path`可以指定根目录的位置，如果想指定多个位置，用`:`分隔开就可以了，像`PATH`一样，这个选项的设置是覆盖的，如果使用，必须指定出所有需要的位置

## build

```Makefile
PROTO_SRC=./gen.proto

message:
	protoc --go_out=. --proto_path=.:$$GOPATH/src:$$GOPATH/src/github.com/googleapis/googleapis $(PROTO_SRC)

grpc:
	protoc --go-grpc_out=require_unimplemented_servers=false:. --proto_path=.:$$GOPATH/src:$$GOPATH/src/github.com/googleapis/googleapis $(PROTO_SRC)

gateway:
	protoc --grpc-gateway_out=. --proto_path=.:$$GOPATH/src:$$GOPATH/src/github.com/googleapis/googleapis $(PROTO_SRC)

swagger:
	protoc --swagger_out=. --proto_path=.:$$GOPATH/src:$$GOPATH/src/github.com/googleapis/googleapis $(PROTO_SRC)

validate:
	protoc --validate_out=lang=go:$(OUT_ROOT_PATH) --proto_path=.:$$GOPATH/src:$$GOPATH/src/github.com/googleapis/googleapis $(PROTO_SRC)

.PHONY: message grpc gateway swagger validate
```

### `require_unimplemented_servers=false`

新版本的`protoc-gen-go`移除了生成`grpc`代码的功能，生成`grpc`功能独立成为一个工具`protoc-gen-go-grpc`,在`v1.0.0`和`v1.1.0`上通过默认方式产生的`grpc`代码都会包含一个无法实现的接口`mustEmbedUnimplementedServServer`，通过`require_unimplemented_servers=false`可以阻止生成这个接口，[原因得看这里](https://pkg.go.dev/google.golang.org/grpc/cmd/protoc-gen-go-grpc#section-readme)


**[demo_code](https://github.com/AHAOAHA/Demo/tree/master/golang/proto)**

## 存在的问题

**`google.protobuf.Struct`类型的数据用`proto`反序列化同一个对象产生的二进制数据顺序可能是不同的，但使用`json`或者`jsonpb`是不会出现这样的问题的。**
