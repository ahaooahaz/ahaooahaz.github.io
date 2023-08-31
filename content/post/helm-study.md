---
author: ahaooahaz
image: https://media.githubusercontent.com/media/irisHYT/ImageHosting0/main/images/1690861871031.webp
urlname: helm-study
date: 2022-10-10 10:53:37
title: helm学习笔记
tags:
  - technical
---

helm学习笔记。

<!--more-->

# 安装

*TBD*

# 语法

## 测试模板的渲染但不实际安装

```bash
helm install --debug --dry-run goodly-guppy ./mychart
```

## 内置对象

内置的值都是以大写字母开始。

### Release

Release是在模板中访问的顶层对象之一，默认存在

1. Release.Name
2. Release.Namespace
3. Release.IsUpgrade: 如果当前操作是升级或者回滚的话，该值为true
4. Release.IsInstall: 如果当前操作是安装的话，该值为true
5. Release.Revision: 此次修订的版本号，初始安装时为1，后续每一次升级和回滚自增
6. Release.Service: 用来渲染当前模板

### Values

Values对象是从values.yaml文件和用户提供的文件穿进模板的，默认为空

### Chart

Chart.yaml文件内容。Chart.yaml中的所有数据通过Chart都可以访问

### Files

在chart中提供访问所有的非特殊文件的对象，不能使用它访问Template对象，只能访问其他文件。

*TBD*

### Capabilities

提供关于k8s集群支持功能的信息

*TBD*

### Template

包含当前被执行的当前模板信息

1. Template.Name: 当前模板的命名空间文件路径
2. Template.BasePath: 当前chart模板目录的路径

## Values

Values内容来源有多个位置：

1. chart中的values.yaml文件
2. 如果是子chart，则来源就是父chart的values.yaml文件
3. 使用`-f`参数自定义的values.yaml文件
4. 使用`--set`参数传递的单个参数

默认使用values.yaml，可以被父chart中的values.yaml覆盖，继而被用户提供的values.yaml文件覆盖，最后会被`--set`参数覆盖，优先级依次递增

> 如何删除已经存在的value？
> 
> 通过更高的优先级方式将已经存在的key设置为null来删除已经存在的默认value值。

## 模板函数和流水线

### 模板函数

```yaml
{{ functionName arg1 arg2 ... }}
```

1. quote STRING: 为引用的value值添加双引号
2. upper STRING: 转换为大写
3. repeat COUNT STRING: 将STRING重复COUNT次
4. default: 为模板指定一个默认值，当value中为null时，default值生效，在实际环境中，所有的默认值应该卸载values.yaml文件中
5. lookup STRING STRING STRING STRING:

| parameter | type | option |
| :---: | :---: | :---: |
| apiVersion | string | require |
| kind | string | require |
| namespace | string | optional |
| name | string | optional |

name和namespace都是可选的参数，*TBD*

[模板函数分类以及列表](https://helm.sh/zh/docs/chart_template_guide/function_list/)

## 流控制

- if/else
- with: 用来指定范围
- range
- define: 在模板中声明一个新的命名模板
- template: 导入一个命名模板
- block: 声明一种特殊的可填充的模板块

### if/else

```yaml
{{ if PIPELINE }}
# Do something
{{ else if  OTHER PIPELINE }}
# Do something
{{ else }}
# Default case
{{ end }}
```

**需要注意空格的控制**，在模板引擎运行时，会移除`{{}}`中的内容，留下的空白会保持原样，所以需要注意要让留下的内容是一个合法的yaml语法格式

- `{{-`表示向左删除空白
- `-}}`表示向右删除空白

### with

**在with限定的作用域内，无法访问父作用域的值**，可以通过`$`根作用域访问

```yaml
{{- with .Values.favorite }}
  drink: {{ .drink | default "tea" | quote }}
  food: {{ .food | upper | quote }}
  release: {{ $.Release.Name }}
  {{- end }}
```

*TBD*

### range

```yaml
toppings: |-
    {{- range $.Values.pizzaToppings }}
    - {{ . | title | quote }}
    {{- end }}
```

- `|-`:声明多行字符串